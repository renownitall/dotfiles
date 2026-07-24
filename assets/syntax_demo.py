#!/usr/bin/env python3
from __future__ import annotations
import sys
import os
import re
import json
import asyncio
import functools
import dataclasses
from abc import ABC, abstractmethod
from typing import TypeVar, Generic, Optional, Union, Callable, Any
from collections.abc import Iterator, Sequence
from datetime import datetime
from pathlib import Path
from enum import Enum, auto, Flag
from contextlib import contextmanager, asynccontextmanager

T = TypeVar("T")
K = TypeVar("K")

MAX_BUFFER_SIZE = 0xFFFF
BINARY_FLAGS = 0b1010_1100
OCTAL_PERMS = 0o755
SCIENTIFIC = 6.022e23
COMPLEX_NUM = 3 + 4j
BIG_NUMBER = 1_000_000_000


class Status(Enum):
    PENDING = auto()
    RUNNING = auto()
    COMPLETED = "completed"
    FAILED = -1


class Permission(Flag):
    READ = auto()
    WRITE = auto()
    EXECUTE = auto()
    ALL = READ | WRITE | EXECUTE


@dataclasses.dataclass(frozen=True, slots=True)
class Config:
    name: str
    version: tuple[int, int, int] = (1, 0, 0)
    debug: bool = False
    settings: dict[str, Any] = dataclasses.field(default_factory=dict)

    def __post_init__(self) -> None:
        object.__setattr__(self, "_created", datetime.now())


class Repository(ABC, Generic[T, K]):
    _instances: dict[type, Repository] = {}

    def __init_subclass__(cls, **kwargs: Any) -> None:
        super().__init_subclass__(**kwargs)
        cls._instances[cls] = None

    @abstractmethod
    async def get(self, key: K) -> Optional[T]: ...

    @abstractmethod
    async def save(self, key: K, value: T) -> bool: ...


def retry(
    max_attempts: int = 3,
    delay: float = 1.0,
    exceptions: tuple[type[Exception], ...] = (Exception,),
) -> Callable[[Callable[..., T]], Callable[..., T]]:
    def decorator(func: Callable[..., T]) -> Callable[..., T]:
        @functools.wraps(func)
        async def wrapper(*args: Any, **kwargs: Any) -> T:
            nonlocal max_attempts
            last_exception: Optional[Exception] = None
            for attempt in range(max_attempts):
                try:
                    return await func(*args, **kwargs)
                except exceptions as e:
                    last_exception = e
                    await asyncio.sleep(delay * (2**attempt))
            raise last_exception or RuntimeError("Unexpected retry failure")

        return wrapper

    return decorator


class DataProcessor(Repository[dict[str, Any], str]):
    __slots__ = ("_cache", "_lock", "__weakref__")

    _PATTERN: re.Pattern[str] = re.compile(
        r"(?P<key>\w+)\s*[:=]\s*(?P<value>[^\n;]+)", re.IGNORECASE | re.MULTILINE
    )

    def __init__(self, *, cache_size: int = 100) -> None:
        self._cache: dict[str, Any] = {}
        self._lock = asyncio.Lock()
        self.__cache_size = cache_size

    def __repr__(self) -> str:
        return f"{self.__class__.__name__}(cache_size={self.__cache_size!r})"

    def __len__(self) -> int:
        return len(self._cache)

    def __contains__(self, key: object) -> bool:
        return key in self._cache

    def __getitem__(self, key: str) -> Any:
        if key not in self._cache:
            raise KeyError(f"Key {key!r} not found")
        return self._cache[key]

    def __setitem__(self, key: str, value: Any) -> None:
        self._cache[key] = value

    def __delitem__(self, key: str) -> None:
        del self._cache[key]

    def __iter__(self) -> Iterator[str]:
        yield from self._cache

    @property
    def cache_size(self) -> int:
        return self.__cache_size

    @cache_size.setter
    def cache_size(self, value: int) -> None:
        if value < 0:
            raise ValueError("Cache size must be non-negative")
        self.__cache_size = value

    @classmethod
    def create_default(cls) -> DataProcessor:
        return cls(cache_size=50)

    @staticmethod
    def validate_key(key: str) -> bool:
        return bool(key) and key.isidentifier()

    @retry(max_attempts=3, exceptions=(IOError, OSError))
    async def get(self, key: str) -> Optional[dict[str, Any]]:
        async with self._lock:
            return self._cache.get(key)

    @retry(max_attempts=2, delay=0.5)
    async def save(self, key: str, value: dict[str, Any]) -> bool:
        async with self._lock:
            self._cache[key] = value
            return True

    def process_batch(
        self,
        items: Sequence[tuple[str, Any]],
        *,
        transform: Callable[[Any], Any] = lambda x: x,
        filter_fn: Optional[Callable[[str, Any], bool]] = None,
    ) -> dict[str, Any]:
        return {
            k: transform(v) for k, v in items if filter_fn is None or filter_fn(k, v)
        }


@contextmanager
def timer(label: str = "Operation") -> Iterator[dict[str, float]]:
    import time

    stats: dict[str, float] = {"start": 0.0, "end": 0.0, "elapsed": 0.0}
    stats["start"] = time.perf_counter()
    try:
        yield stats
    finally:
        stats["end"] = time.perf_counter()
        stats["elapsed"] = stats["end"] - stats["start"]
        print(f"{label} took {stats['elapsed']:.6f}s")


@asynccontextmanager
async def managed_resource(name: str):
    print(f"Acquiring {name}")
    try:
        yield {"resource": name, "active": True}
    except Exception as exc:
        print(f"Error with {name}: {exc}")
        raise
    finally:
        print(f"Releasing {name}")


def counter_generator(start: int = 0, end: int | None = None) -> Iterator[int]:
    current = start
    while end is None or current < end:
        received = yield current
        if received is not None:
            current = received
        else:
            current += 1


def parse_command(command: str | list | dict | None) -> str:
    match command:
        case None:
            return "No command"
        case str() as s if s.startswith("!"):
            return f"Special: {s[1:]}"
        case str(cmd):
            return f"Command: {cmd}"
        case [first, *rest]:
            return f"List: {first} + {len(rest)} more"
        case {"action": action, "target": target, **extra}:
            return f"Action {action} on {target} ({extra})"
        case {"action": action}:
            return f"Action: {action}"
        case _:
            return "Unknown format"


TEMPLATE = f"""\
Configuration Report
{"=" * 40}
Generated: {{timestamp}}
Version: {{version!r}}
"""

RAW_PATTERN = r"\b[A-Z][a-z]+(?:\s+[A-Z][a-z]+)*\b"
BYTES_DATA = b"\x00\x01\x02\xff\xfe"
UNICODE_STR = "Ωmega • αlpha • βeta → γamma ∞"


def analyze(data: list[int]) -> dict[str, Any]:
    return {
        "count": (n := len(data)),
        "sum": (total := sum(data)),
        "mean": total / n if n > 0 else 0,
        "positive": [x for x in data if x > 0],
        "squared": {x: x**2 for x in data},
        "indexed": {i: v for i, v in enumerate(data)},
        "pairs": [
            (x, y) for x in range(5) for y in range(5) if (x + y) % 2 == 0 and x != y
        ],
    }


class BaseError(Exception):
    def __init__(self, message: str, *, code: int = -1) -> None:
        super().__init__(message)
        self.code = code
        self.timestamp = datetime.now()


class ValidationError(BaseError):
    pass


class ProcessingError(BaseError):
    def __init__(
        self, message: str, *, code: int = -1, cause: Exception | None = None
    ) -> None:
        super().__init__(message, code=code)
        self.__cause__ = cause


JsonValue = Union[
    str, int, float, bool, None, list["JsonValue"], dict[str, "JsonValue"]
]
Callback = Callable[[str, int], bool]
Result = tuple[bool, str | None, dict[str, Any]]


def serialize(
    obj: JsonValue, *, indent: int | None = None, sort_keys: bool = False
) -> str:
    return json.dumps(obj, indent=indent, sort_keys=sort_keys)


async def main() -> int:
    global MAX_BUFFER_SIZE

    processor = DataProcessor(cache_size=100)
    config = Config(
        name="syntax-demo",
        version=(2, 5, 0),
        debug=True,
        settings={"theme": "dark", "font_size": 14},
    )

    test_data = [1, -2, 3, 0, -5, 8, 13, -21, 34]

    with timer("Analysis"):
        results = analyze(test_data)

    try:
        await processor.save("config", dataclasses.asdict(config))
        retrieved = await processor.get("config")

        match retrieved:
            case {"name": name, "debug": True}:
                print(f"Debug mode enabled for {name}")
            case {"name": name}:
                print(f"Production mode: {name}")
            case None:
                raise ValidationError("Config not found", code=404)

    except ValidationError as e:
        print(f"Validation failed: {e} (code={e.code})")
        return 1
    except (IOError, OSError) as e:
        print(f"IO Error: {e}")
        return 2
    except Exception:
        raise
    else:
        print("Configuration loaded successfully")
    finally:
        print("Initialization complete")

    commands = [
        None,
        "!restart",
        "status",
        ["get", "user", "123"],
        {"action": "delete", "target": "cache"},
        {"action": "update", "target": "db", "force": True, "timeout": 30},
    ]

    for cmd in commands:
        result = parse_command(cmd)
        print(f"  {cmd!r:45} -> {result}")

    gen = counter_generator(0, 5)
    values = [next(gen) for _ in range(3)]
    gen.send(10)
    values.extend(gen)

    async with managed_resource("database"):
        tasks = [asyncio.create_task(processor.get(f"key_{i}")) for i in range(5)]
        completed = await asyncio.gather(*tasks, return_exceptions=True)

    matrix = [[i * j for j in range(1, 6)] for i in range(1, 6)]
    flattened = [cell for row in matrix for cell in row]
    even_only = list(filter(lambda x: x % 2 == 0, flattened))
    odd_set = {x for x in flattened if x % 2 != 0}

    operations: dict[str, Callable[[int, int], int]] = {
        "add": lambda a, b: a + b,
        "sub": lambda a, b: a - b,
        "mul": lambda a, b: a * b,
        "div": lambda a, b: a // b if b != 0 else 0,
        "mod": lambda a, b: a % b if b != 0 else 0,
        "pow": lambda a, b: a**b,
        "band": lambda a, b: a & b,
        "bor": lambda a, b: a | b,
        "xor": lambda a, b: a ^ b,
        "lshift": lambda a, b: a << b,
        "rshift": lambda a, b: a >> b,
    }

    assert all(callable(op) for op in operations.values()), "All must be callable"
    assert processor.cache_size >= 0, f"Invalid cache size: {processor.cache_size}"

    is_valid = (
        processor is not None
        and len(processor) >= 0
        and config.debug is True
        or config.debug is False
        and not config.debug
    )

    ternary_result = "enabled" if config.debug else "disabled"
    chained_comparison = 0 < len(test_data) < 100 <= MAX_BUFFER_SIZE

    status = Status.COMPLETED
    perms = Permission.READ | Permission.WRITE
    has_execute = Permission.EXECUTE in perms

    file_path = Path(__file__).resolve()
    parent_exists = file_path.parent.exists()

    formatted_output = TEMPLATE.format(
        timestamp=datetime.now().isoformat(), version=config.version
    )

    print(f"""
Summary:
  Config: {config.name} v{".".join(map(str, config.version))}
  File: {file_path.name}
  Cache entries: {len(processor)}
  Analysis metrics: {len(results)}
  Matrix sum: {sum(flattened)}
  Even count: {len(even_only)}, Odd count: {len(odd_set)}
  Status: {status.name} ({status.value})
  Permissions: {perms!r} (execute={has_execute})
  Debug: {ternary_result}
  Valid chain: {chained_comparison}
  Bytes sample: {BYTES_DATA.hex()}
  Unicode: {UNICODE_STR[:20]}...
""")

    return 0


if __name__ == "__main__":
    try:
        exit_code = asyncio.run(main())
    except KeyboardInterrupt:
        print("\nInterrupted by user")
        exit_code = 130
    except SystemExit as e:
        exit_code = e.code if isinstance(e.code, int) else 1

    sys.exit(exit_code)
