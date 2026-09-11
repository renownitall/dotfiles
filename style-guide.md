# Documentation Style Guide

This guide is the single source of truth for documentation style in this
repository. It combines the team's conventions with the Google Developer
Documentation Style Guide, which fills in any topic not covered here. When the
two differ, follow this guide: it prioritizes clarity and beginner-friendliness
over strict adherence to Google's conventions. See the
[Precedence Note](#precedence-note) for details.

## Table of Contents

1. [Documentation Workflow & Accuracy](#documentation-workflow--accuracy)
2. [Tone & Voice](#tone--voice)
3. [Structure & Organization](#structure--organization)
4. [Formatting](#formatting)
5. [Punctuation](#punctuation)
6. [Grammar & Word Choice](#grammar--word-choice)
7. [Code Examples & Snippets](#code-examples--snippets)
8. [UI Elements](#ui-elements)
9. [Accessibility & Inclusivity](#accessibility--inclusivity)
10. [Enforcement](#enforcement)
11. [Precedence Note](#precedence-note)

---

## Documentation Workflow & Accuracy

Write documentation that reads like a clear, well-structured textbook for
readers with little to no prior experience. The result must be informative, easy
to follow, technically accurate, and natural for the repository.

- **Read before writing.** Read every existing documentation file and explore
  the source code before writing anything. Build a complete understanding of the
  system, its parts, and how those parts relate to each other.
- **Verify against the code.** Check whether each document is current or
  outdated by comparing it directly against the codebase and observable
  repository behavior. Do not guess about currency.
- **Prefer the code over the docs.** If the code and documentation disagree,
  favor the code and update the documentation accordingly.
- **Don't invent behavior.** Do not make claims that the code or existing
  project conventions do not support. If a concept matters for understanding the
  repository, explain it even if the current docs only mention it briefly.
- **Mark uncertainty only when evidence is genuinely incomplete.**
- **Preserve the author's voice.** Analyze the original writer's tone,
  vocabulary level, sentence rhythm, and explanation patterns, and keep them in
  the rewrite. The revision should feel like a stronger, clearer version of the
  original writing, not a different author. Never imitate mistakes, confusion,
  or poor structure.
- **Proofread against a checklist.** Before finishing, verify that the text
  matches the original author's style, reads like a beginner-friendly textbook,
  introduces concepts in a logical order, defines terms on first use, uses
  direct technical language, follows every rule in this guide, and is
  technically accurate.

---

## Tone & Voice

- **Use a conversational, friendly, and respectful tone** that sounds like a
  knowledgeable friend, without slang, frivolity, or pedantry. Don't write
  exactly the way you speak, but aim for conversational rather than formal.
- **Use direct, literal, precise language.** Say what the system does, how it
  works, and why it matters. Do not use metaphors, idioms, or figurative
  language, and do not use decorative phrasing when a simpler sentence is
  clearer.
- **Keep the writing informative, not dramatic or promotional.** Do not make
  excessive claims: avoid superlatives like _best_, _simplest_, _fastest_,
  _never_, and _always_, and use _ensure_ and _guarantee_ only when something
  truly can be ensured or guaranteed. Limit claims to verifiable information
  that will remain true over the lifespan of the documentation.
- **Address the reader as _you_.** Use second person instead of first person
  (_we_, _our_, _us_), and use the imperative for instructions (the _you_ is
  implied). Use the word _user_ only for the users of the software that the
  reader is developing. You may use _we_ to refer to the team or organization
  when the antecedent is clear.
- **Keep the author's first-person voice where it exists.** Older docs describe
  the author's own setup with _my_ and _I_; don't rewrite that voice into second
  person (see [Precedence Note](#precedence-note)). Write new prose in second
  person.
- **Identify your audience.** Make it clear who the _you_ is (developer,
  sysadmin, beginner) and address that audience consistently throughout the
  document, ideally with an explicit audience statement near the beginning.
- **Don't attribute human qualities to software or hardware.** Say what a
  program does, not what it "sees," "tells," or "wants."
  - ✅ **Recommended**: A Delimiter object specifies where to split a string.
  - ❌ **Not recommended**: A Delimiter object tells the splitter where a string
    should be broken.
- **Use common contractions** such as _you're_, _don't_, and _there's_. Don't
  invent contractions (_guides're_) or use three-word contractions
  (_mightn't've_).
- **Avoid everywhere possible:**
  - Buzzwords and unexplained jargon.
  - Placeholder phrases like _please note_ and _at this time_.
  - Choppy or long-winded sentences, and starting every sentence the same way
    (_You can_, _To do_).
  - Exclamation points. Never use them in concept or reference docs, and avoid
    them in procedures. Use a period for completion steps ("The VM is
    created.").
  - _Let's_ phrasing, _simply_, _It's that simple_, _It's easy_, _quickly_, and
    similar filler in procedures.
  - Internet slang and abbreviations like _tl;dr_ and _ymmv_.
  - Current pop-culture references, and any phrasing that denigrates or insults
    any group of people.
- **Don't say _please_ in instructions.** It adds no information and overdoes
  the politeness.
  - ✅ **Recommended**: To view the document, click **View**.
  - ❌ **Not recommended**: To view the document, please click **View**.

---

## Structure & Organization

### Document shape

- **Give every document a clear beginning, middle, and end.** Use the beginning
  to set expectations, the body to build understanding step by step, and the
  ending to reinforce what the reader has learned.
- **Introduce each concept before using it**, and move from simple ideas to more
  advanced ideas in a clear order. Do not assume background knowledge the reader
  has not been given.
- **Define each important term the first time it appears.** Explain why
  something matters before expecting the reader to use it.
- **Provide context instead of assuming knowledge.** If a few sentences of
  context help the reader, include them rather than linking away.
- **Document only the current state.** Don't pre-announce future features, and
  avoid time-anchoring words like _now_, _new_, _currently_, _soon_, and
  _latest_ when describing product capabilities. If you must use _new_, give a
  reference point such as a date or version.

### Headings

- **Use sentence case** for all headings and titles: capitalize only the first
  word, the first word after a colon, and proper nouns. Don't end a heading with
  a period.
- **Use a heading hierarchy without skipping levels**, and give every heading
  unique, descriptive text that is followed by content. Use `h1` (one per page)
  for the page title.
- **Use task-based headings** (starting with a bare infinitive) for procedures,
  and noun-phrase headings for conceptual sections. Avoid starting headings with
  _-ing_ verb forms when possible.
  - ✅ **Recommended**: Create an instance / Transfer data sets
  - ❌ **Not recommended**: Creating an instance / Transferring data sets
- **Don't use numbers in headings to indicate sequence**, don't put links in
  headings, and avoid code items in headings (if unavoidable, add a descriptive
  noun in code font).
- **Refer to a group of sections as _the following sections_**, not _this
  section_ or _these sections_.

### Paragraphs

- **One idea per paragraph**, in the fewest words and sentences possible. A
  paragraph longer than 5-6 sentences usually tries to convey too much; break it
  up unless it contains a single idea. A one-sentence paragraph is fine.
- **Put the most important information first** in the sentence and in the
  paragraph. Don't hide the key point at the end.
- **Use shorter sentences** (fewer than 26 words when possible).
- **Left-align text.** Don't center, full-justify, or right-align, and don't
  force line breaks within sentences and paragraphs.

### Lists

- **Use a numbered list for sequences** (ordered steps, phases, priorities) and
  a bulleted list for everything else. Use a description list for
  term/definition pairs. Don't use a list for a single item.
- **Introduce lists with a complete sentence**, not a partial sentence completed
  by the list items. End the introduction with a colon if it immediately
  precedes the list, or a period if other material intervenes.
  - ✅ **Recommended**: Use the **Submit** button for any of the following
    purposes:
  - ❌ **Not recommended**: Use the **Submit** button to: (list follows)
- **Make list items parallel** in structure, and be consistent in capitalization
  and punctuation: start items with a capital letter, and end items with a
  period except for single words, items without verbs, and items entirely in
  code font or link text.
- **Don't end a list with _etc._ or _and so on_.** Introduce the list in a way
  that makes clear it isn't all-inclusive.
- **Don't use _(s)_ optional-plural notation** (e.g., `API key(s)`). Use _one or
  more_ or choose the appropriate singular or plural form.

### Procedures

- **Use numbered steps** for procedures, one action per step, each step starting
  with an imperative verb and written as a complete sentence. If a procedure has
  only one step, write it as a single sentence in a bulleted list.
- **Introduce a procedure with a complete sentence** (imperative is fine) that
  adds context beyond the heading. Don't introduce with a partial sentence
  completed by the steps.
  - ✅ **Recommended**: To customize the buttons, follow these steps:
  - ❌ **Not recommended**: To customize the buttons:
- **State the condition or goal before the instruction.**
  - ✅ **Recommended**: To delete the entire document, click **Delete**.
  - ❌ **Not recommended**: Click **Delete** if you want to delete the entire
    document.
- **State the location (tool or UI) before the action.**
  - ✅ **Recommended**: In Google Docs, click **File > New > Document**.
  - ❌ **Not recommended**: Click **File > New > Document** in Google Docs.
- **State the action first, then the result or justification**, keeping both in
  the same paragraph.
- **Use sub-steps sparingly**: lowercase letters for sub-steps, lowercase Roman
  numerals for sub-sub-steps.
- **Mark optional steps with _Optional:_ at the start of the step**, not with
  parentheses.
- **Don't include keyboard shortcuts** in procedures, and **don't use
  directional language** (_above_, _below_, _right-hand side_) to orient the
  reader. If a UI element is hard to find, use its icon plus tooltip name or
  provide a screenshot.
- **When multiple approaches exist, document one.** Pick the shortest, simplest,
  keyboard-only approach. If you must document alternatives, separate them into
  different pages, headings, or tabs.
- **Avoid repeating procedures**; reference and link to them instead.

### Tables

- **Use a table only for two-dimensional data** (three or more related pieces of
  data per item). Use lists for single units and description lists for
  term/definition pairs. Don't use tables to lay out a page or code.
- **Introduce a table with a complete sentence** (e.g., "as listed in the
  following table") because screen readers may not preannounce tables.
- **Use sentence case** in all table content and headings, keep headings
  concise, and don't end heading cells with punctuation.
- **Don't merge cells**, don't use tables in the middle of a numbered procedure,
  and sort rows in a logical or alphabetical order.

### Notices

- **Use notices sparingly.** Note = useful but not critical; Caution = proceed
  carefully; Warning = don't do this, possibly irreversible. If unsure whether
  something needs a notice, write it in regular text first.
- **Don't group two or more notices together**, and don't use notes for
  cross-references, prerequisites, full procedural steps, or information
  necessary for success.

---

## Formatting

### Text formatting

- **Use bold only for UI elements and run-in headings**, not for emphasis. In
  Markdown, use `**` for bold.
- **Use italics sparingly**: for terms you're defining on first mention, for
  words as words, and for titles of full-length works. Use `_` for italics in
  Markdown.
- **Use code font** (backticks in Markdown) for code-related text: filenames,
  class and method names, attribute and parameter names, commands, command
  output, data types, HTTP status codes and verbs, placeholders, and text the
  reader should enter verbatim. See
  [Code Examples & Snippets](#code-examples--snippets).
- **Use straight quotation marks and apostrophes**, never curly ones. Don't put
  quotation marks around code unless they're part of the code.
- **Don't use _&_ for _and_** in prose, headings, or navigation, except when
  referencing a UI element or menu that uses it, or in code.
- **Don't use all-caps or camel case in prose** (except in official names,
  abbreviations, or code). Don't describe casing styles by name (_camel case_,
  _snake case_); describe the format and give an example.

### Dates and times

- This repository almost never documents dates or times. Follow the Google guide
  on the rare occasion they appear, and never use numeric dates like `04/05/09`;
  use `YYYY-MM-DD` if a numeric format is unavoidable.

### Numbers and units

- **Spell out numbers zero through nine; use numerals for 10 and greater.**
  Always use numerals for versions, technical quantities, measurements, prices,
  percentages, and numbers without units. Spell out ordinals ("fifth", not
  "5th").
- **Use a period for the decimal point and commas as digit-group separators**
  (1,532,784).
- **Use numerals with the percent sign** and no space (40%). If a percentage
  starts a sentence, spell out both ("Forty percent of the files").
- **Use a hyphen for ranges of numbers** ("2012-2016", "8-20 files"), never an
  en dash, and don't mix hyphens with _from_/_to_ ("from 8-20 files" is wrong).
- For dimensions, fractions, currencies, and decimal/binary unit systems, follow
  the Google guide. This repository rarely needs them.

### Images

- **Use images only when they add useful information.** Don't use images of
  text, code samples, or terminal output; use actual text. Don't present new
  information only in an image; provide an equivalent text explanation.
- **Provide alt text for every image**, summarizing the image's intent in
  context, in 155 characters or less, without phrases like "Image of". For
  purely decorative images, use empty alt text.
- **Don't use animated GIFs.** Screenshots are PNG files; capture real screens
  rather than drawing diagrams. The Google guide's SVG preference does not apply
  to them.
- **Introduce images with a complete sentence** and refer to them by number or
  as "the preceding/following diagram", never as "the image above" or "the
  diagram below".
- **Don't include PII in screenshots**; hide it with a solid-color overlay,
  never a blur or mosaic.

### Links

- **Use short, unique, descriptive link text** that makes sense out of context.
  Don't use _click here_, _this document_, _this article_, or a raw URL as link
  text. Put important words at the beginning of the link text.
  - ✅ **Recommended**: For more information, see [Load balancing and scaling].
  - ❌ **Not recommended**: Want more? [Click here!]
- **Introduce cross-references consistently**: "For more information, see
  [link]" or "For more information about X, see [link]". Use _see_, not _on_ or
  _refer to_.
- **Link selectively**: link to the most relevant destination, don't duplicate
  links on a page, and include the abbreviation in the link text when the term
  is introduced with one.
- **Explain unexpected link behavior**: if a link downloads a file, opens email,
  or jumps within the same page, say so. Don't force links to open in a new tab.

### Filenames, file types, and example data

- **Name files in lowercase with hyphens between words** (`query-data.html`),
  using only ASCII characters. Use underscores only for consistency with an
  existing directory.
- **Refer to file types by their formal name, not the extension** ("a PNG file",
  not "a `.png` file"). When referring to a specific file, use code font and the
  word _file_ ("the `pg_hba.conf` file").
- **Use only fictitious example data**: example.com/example.org/example.net
  domains, the example person names from the Google guide (Alex, Amal, Dana,
  Kai, and so on), phone numbers in the 800-555-0100 through 800-555-0199 range,
  and documentation IP addresses (192.0.2.0/24, 198.51.100.0/24, 203.0.113.0/24,
  2001:db8::). Never reveal real names, addresses, or credentials.

---

## Punctuation

### Semicolons (team rule, overrides Google)

- **Never use semicolons in prose.** If a sentence tempts you to use one,
  rewrite it as two sentences or join the clauses with a conjunction.
  - ✅ **Recommended**: The build becomes faster as a result.
  - ❌ **Not recommended**: The result: a faster build; this saves time.
- Semicolons are allowed only inside code blocks or inline code, where the
  programming language requires them. Google's guide permits semicolons in a few
  specific constructions (joining closely related clauses, before conjunctive
  adverbs, in complex series); the team's blanket ban takes precedence in this
  repository, and rewriting the sentence is always preferred.
- **Scope.** The ban covers new prose. Pre-existing deviations are tracked as
  warnings by `make lint-docs`; don't add new ones.

### Em dashes and en dashes (team rule, overrides Google)

- **Never use em dashes or en dashes in prose.** Rewrite the sentence instead.
  Google recommends em dashes for breaks and interruptions; the team's ban takes
  precedence in this repository.
  - ❌ **Not recommended**: The core idea—simplicity—guides the design.
  - ✅ **Recommended**: The core idea of the design is simplicity.
- **Hyphens are fine and often required** for compound modifiers and number
  ranges; see [Grammar & Word Choice](#grammar--word-choice). Don't use a hyphen
  or double hyphen as a dash.
- **Scope.** The ban covers new prose. Pre-existing deviations are tracked as
  warnings by `make lint-docs`; don't add new ones. Function signature headers
  (`name ARGS — description`) are reference entries rather than prose sentences,
  and are exempt; `lint-docs` does not flag them.

### Colons (merged rule)

- **Use a colon only to introduce a list, code sample, table, or sub-step**
  where the text before the colon is a complete sentence.
  - ✅ **Recommended**: The fields are defined as follows:
  - ❌ **Not recommended**: The fields are:
- **Never use the "label, summary, or setup then colon" pattern in prose.** This
  means a sentence that puts a label or setup before a colon and attaches the
  real content after it. Rewrite it as a complete sentence.
  - ❌ **Not recommended**: The goal: explain the system clearly. / Overview:
    this module handles authentication. / This function does one thing: it
    parses the input.
  - ✅ **Recommended**: The goal of this section is to explain the system
    clearly. / This module handles authentication. / This function parses the
    input.
- Start the text after a colon with a lowercase letter unless it's a proper
  noun, a quotation, a heading, or a notice label (Note:, Caution:).
- **Scope.** The label-then-colon ban covers new prose. Pre-existing deviations
  are tracked as warnings by `make lint-docs`; don't add new ones. Schematic
  comment headers (`Case A:`, `Action:`, `Called by:`, numbered scenario titles)
  are reference entries rather than prose sentences, and are exempt; `lint-docs`
  does not flag them.

### Commas

- **Use the serial (Oxford) comma** before the final _and_ or _or_ in a series
  of three or more items.
  - ✅ **Recommended**: Locations are divided into zones, regions, and
    multi-regions.
  - ❌ **Not recommended**: Locations are divided into zones, regions and
    multi-regions.
- **Put a comma after introductory words and phrases** ("Finally, ...", "Based
  on the requirements, ...").
- **Put a comma before a coordinating conjunction joining two independent
  clauses**, unless both clauses are very short.

### Hyphens

- **Hyphenate compound modifiers before a noun** when needed for clarity (a
  well-designed app), and don't hyphenate the same compound after a verb (the
  app is well designed). Don't hyphenate _-ly_ adverbs (publicly available
  implementations).
- **Don't use a hyphen between a prefix and its noun** in general (metadata,
  preprocessing), except after _self_ and _cross_ (self-managing, cross-region),
  before capitals or numbers (non-Google, post-2000), and where needed to avoid
  confusion (re-sign).
- **Write compound nouns closed when established** (webpage, hostname,
  workaround), and use a hyphen for number ranges rather than an en dash.

### Other punctuation

- **Periods**: end sentences with a period, never headings; leave one space
  between sentences. Put the period inside parentheses only when the parentheses
  contain a complete sentence.
- **Ellipses**: don't use them in prose. Use three dots (`...`) only in command
  syntax to show repeatable arguments or omitted output lines, and don't use the
  ellipsis character (`…`).
- **Parentheses**: use sparingly, and never put important information in them.
  Keep parenthetical thoughts short, or use two sentences.
- **Quotation marks**: use straight double quotes; periods and commas go inside
  quotation marks. Use single quotes only in code or when nesting a quote. Quote
  titles of shorter works; italicize full-length titles.
- **Slashes**: avoid them outside of code and file paths. Don't use slashes for
  alternatives or _and/or_; write out the meaning.
- **Exclamation points**: avoid them; see [Tone & Voice](#tone--voice).

---

## Grammar & Word Choice

### Voice, tense, and sentence structure

- **Use active voice.** Make clear who performs the action. Passive voice is
  acceptable only to emphasize the object ("The file is saved"), de-emphasize
  the actor ("Over 50 conflicts were found"), or when the actor is irrelevant.
  - ✅ **Recommended**: Send a query to the service. The server sends an
    acknowledgment.
  - ❌ **Not recommended**: The service is queried, and an acknowledgment is
    sent.
- **Use present tense** for general behavior, reserving future tense for actions
  that genuinely occur later. Avoid the hypothetical _would_.
  - ✅ **Recommended**: If you send an unsubscribe message, the server removes
    you from the mailing list.
  - ❌ **Not recommended**: You can send an unsubscribe message. The server
    would then remove you from the mailing list.
- **Put the circumstance or condition before the instruction.**
- **Use standard subject + verb + object word order**, and keep the main subject
  and verb close to the beginning of the sentence.
- **Include articles (_a_, _an_, _the_)** even in headings and titles; don't
  skip them for brevity.
- **Ending a sentence with a preposition is fine** where it reads naturally.

### Word choice

- **Use the simplest word that conveys the meaning**: _use_ instead of _utilize_
  or _leverage_; _start_ instead of _commence_; _so_ instead of _consequently_.
  Prefer a single word over a phrase ("some" for "a number of"). Avoid phrasal
  verbs when a simpler verb exists, though exceptions like _set up_, _log in_,
  and _sign in_ are fine.
- **Avoid double negatives** and ambiguous phrasing.
  - ✅ **Recommended**: You can continue without a path.
  - ❌ **Not recommended**: A missing path won't prevent you from continuing.
- **Use helper words that prevent ambiguity**: keep _that_, _which_, and _then_
  even though casual speech drops them ("If the attribute key is not found, then
  the default value is returned").
- **Don't overload modifiers**: no more than two nouns as modifiers of another
  noun, and place modifiers (like _only_) immediately before what they modify.
- **Use each term consistently throughout a document**, including
  capitalization. Don't use the same word as both noun and verb in close
  proximity.
- **Use words in their primary sense**, not metaphorically.

### Recommendations and requirements

- **Choose _must_ for required actions, _can_ for optional actions and possible
  outcomes, and _might_ for possible outcomes.** Avoid _should_, which implies
  that an action is recommended but optional and leaves readers unsure.
  - ✅ **Recommended**: You must set the value to true. / You can also use
    approach B.
  - ❌ **Not recommended**: The value should be true.

### Abbreviations

- **Spell out an abbreviation on first use with the abbreviation in
  parentheses.** An example is "Border Gateway Protocol (BGP)". Italicize both.
  Use the abbreviation alone afterward. If you use a term only once, don't
  introduce the abbreviation at all.
- **Define important terms on first appearance** (team rule): when in doubt,
  spell out, because this documentation is written for beginners. Common
  technical abbreviations (API, URL, HTML, PDF, XML, RAM, USB) rarely need
  spelling out.
- **Don't use _i.e._ or _e.g._; use _that is_ and _for example_.** Avoid _etc._
  in lists. Don't use abbreviations as verbs ("SSH into" is wrong; use "use SSH
  to log in to").
- **Don't use periods with acronyms or initialisms** (BGP, not B.G.P.), and use
  _a_ or _an_ based on pronunciation ("a SQL", "an SAP").

### Capitalization

- **Follow standard American English capitalization**, and don't capitalize
  words just because an abbreviation does: "data manipulation language (DML)".
- **Don't rely on capitalization to convey meaning** (e.g., "Pod" vs "pod");
  write so the distinction is clear from context.
- **Capitalize product and feature names only when they are official names**,
  and never use product names as verbs or form possessives or plurals of
  trademarks ("Google Search's performance" is wrong; use "the performance of
  Google Search").

### Plurals and possessives

- **Use regular plural forms; never form plurals with _'s_** (APIs, not API's).
  For abbreviations ending in _s_, _sh_, _ch_, or _x_, add _es_ (OSes).
- **Use a plural after _one or more_, a singular after _more than one_.** Don't
  use parenthetical plurals.
- **Keep code class names singular**; add a noun ("`Intent` objects", not
  "`Intent`s").
- **Form possessives normally** ('s for singular, apostrophe for plural), but
  never form a possessive from a code item or a product/feature name. Rewrite
  instead ("the value returned by the `wordCount` method", not "`wordCount`'s
  return value").

### Pronouns

- **Make pronouns refer clearly to their antecedents.** Repeat the noun if a
  pronoun would be ambiguous, and follow demonstratives with a noun ("Set this
  value to true", not "Set this to true").
- **Use the singular _they_ as a gender-neutral pronoun.** Don't use _he_ or
  _she_ generically, and never _he/she_ or _(s)he_.
- **Use _that_ for restrictive clauses (no comma) and _which_ for nonrestrictive
  clauses (comma before).** Use _who_ for people.

### Jargon and inclusive language

- **Avoid jargon unless your audience searches for it.** If you use jargon,
  define it in plain language on first reference ("a _cold standby_ (a backup or
  redundant system that's identical to a primary system)"), or write around it.
  If a term appears in code, use it only in code font.
- **Avoid culturally specific references** (holidays, sports, seasons) and
  idioms or humor; they don't translate.
- **Use inclusive language**: gender-neutral phrasing ("person-hours", not
  "man-hours"), no ableist terms (_crazy_, _insane_, _sanity-check_), and no
  socially charged technical terms (_blacklist_, _first-class citizen_). Use
  _allowlist_ and _denylist_ instead, and write around others. When an
  established non-inclusive term is unavoidable in code, reference it once in
  code font and use the preferred term thereafter.
- **Write about people with disabilities respectfully**: "people with
  disabilities", not "the disabled"; "uses a wheelchair", not
  "wheelchair-bound"; "nondisabled person", not "normal".

---

## Code Examples & Snippets

### Code in text

- **Put code-related text in code font** (backticks in Markdown): attribute
  names and values, class names, commands and command output, data types,
  environment variables, filenames and paths, function and method names, HTTP
  status codes and verbs, IP addresses, language keywords, package names, port
  numbers, placeholders, and strings used in code.
- **Don't use code elements as English verbs or nouns.** Don't inflect them (no
  `POST`ing, no plural or possessive forms). Add a noun: "send a `POST`
  request", "the `ADDRESS` constant's value".
- **Refer to a method by name without the class** unless the class is needed for
  clarity.
- **In API reference comments**, phrase the main description as what the method
  does (present tense, third person): "Creates a new task", "Gets the ...",
  "Checks whether ...". Describe each parameter, the return value, and
  exceptions, and tell readers what to use instead when something is deprecated.

### Code samples

- **Precede a code sample with an introductory sentence or paragraph**, ending
  with a colon if it immediately precedes the sample, or a period otherwise.
  - ✅ **Recommended**: The following code sample shows how to use the `get`
    method:
  - ❌ **Not recommended**: Run the following command:
- **Follow the language's indentation conventions** (two spaces per level for
  most languages; tabs for shell, as enforced by `shfmt`), and wrap lines at 80
  characters. The 80-column limit covers prose, comments, and docstrings; table
  rows, code samples, and formatter-owned code lines are exempt.
- **Indicate omitted code with a comment in the language's syntax**, never with
  ellipses (`...`).
- **Keep click-to-copy examples runnable**: avoid optional, mutually exclusive,
  or repeated-argument notation (brackets, braces, pipes, ellipses) in commands
  that the reader will copy. Link to the command reference for the full option
  list instead.
- **Show command output only when it adds value**, introducing it with "The
  output is similar to the following:" or "The output is the following:".
  Separate input and output into separate code blocks, and use `...` on its own
  line for omitted output lines.
- **Use `$` prompts consistently** when showing multi-line command input; the
  prompt is optional for one-line commands.

### Command syntax and placeholders

- **Use square brackets for optional arguments** (`[GLOBAL_FLAG]`), curly braces
  with pipes for mutually exclusive arguments (`{FILE_1|FILE_2}`), and `...` for
  repeatable arguments (`[GLOBAL_FLAG ...]`).
- **Use placeholder names in all-caps with underscore delimiters**
  (`PROJECT_ID`, `INSTANCE_NAME`), never `MY_...` or `YOUR_...` prefixes.
- **Explain every placeholder the first time it is used.** For a single
  placeholder: "Replace `BUILD_ID` with the ID of the build". For two or more,
  follow the command with a "Replace the following:" description list in order
  of appearance.
- **Don't include keyboard shortcuts in procedures** and don't document command
  prompts as part of command syntax.

### UI elements

- **Put UI element names in bold** (buttons, menus, dialogs, fields, tabs,
  checkboxes). Don't use code font for UI elements unless the element is also
  code, in which case use both bold and code font.
- **Follow the label's capitalization, or use sentence case** if labels are
  inconsistent or all-caps.
- **Use the right verbs**: _click_ a button, _select_ or _clear_ a checkbox,
  _enter_ or _type_ text, _press_ a key, _turn on_/_turn off_ a toggle. Don't
  use UI elements as verbs ("Name the account" is wrong; "In the **Name** field,
  enter an account name" is right).
- **Use the right prepositions**: in a dialog, field, list, menu, pane, or
  window; on a page, tab, or toolbar.
- **Use angle brackets for menu paths**, with a nonbreaking space before each
  bracket: **File > New > Document**.
- **For keyboard keys, use `Control+C` style** with spelled-out modifier keys,
  uppercase letter keys, and `Command` instead of `⌘`. Spell out confusing
  characters ("press `Control+?`").
- **Don't use directional language or describe icons by appearance** ("the
  button with three lines"). Use the icon's tooltip name or provide a
  screenshot.

---

## Accessibility & Inclusivity

- **Design for keyboard-only use and screen readers.** Test with a screen
  reader. Ensure all interactive elements are reachable without a mouse.
- **Don't rely on color, size, location, or other visual cues alone** to
  communicate meaning; provide a secondary cue such as a text label.
- **Don't use directional language** (_above_, _below_, _right-hand side_) to
  orient the reader or refer to positions in the document; use _preceding_ or
  _following_ instead.
- **Write in a way that survives without punctuation**: some screen readers skip
  punctuation, so prefer short sentences and avoid exclamation points, question
  marks, and semicolons in prose (the semicolon ban in this guide already
  supports this).
- **Avoid camel case and all-caps** where possible (screen readers may read
  letters individually, and some languages are unicase).
- **Provide alt text for images, captions or transcripts for video and audio**,
  and never use flashing or flickering elements. See
  [Formatting > Images](#formatting).
- **Use semantic HTML**: real heading elements (`h1`-`h6`) in a strict
  hierarchy, `th` for table headers, `button` for buttons. In Markdown, use
  `#`-`###` levels without skipping.
- **Write for a global audience**: simple words, short sentences, consistent
  terminology, unambiguous dates, and no culturally specific references. Support
  translation by keeping content self-contained and literal.
- **Write inclusively**: diverse example names, gender-neutral pronouns, and
  respectful, precise terms for people. See
  [Grammar & Word Choice](#grammar--word-choice).

---

## Enforcement

Each rule in this guide names its enforcer below. `make lint` runs every check,
and `make check` (which CI also runs) includes `lint-docs` alongside the test
suites. Run `python3 scripts/check_docs_style.py --strict` to fail on warnings
as well.

| Rule                                                                            | Enforced by                                                                          |
| :------------------------------------------------------------------------------ | :----------------------------------------------------------------------------------- |
| Prose wrapped at 80 columns                                                     | `prettier` (`proseWrap: always`) and `lint-docs` E1                                  |
| Key combos in `Control+C` style, UI names in bold                               | `lint-docs` E2, E3                                                                   |
| Sentence-case content, task-based headings, no code or `-ing` forms in headings | `lint-docs` E4, E5 and human review                                                  |
| Comments and docstrings wrapped at 80 columns                                   | `lint-docs` E6 (`ruff format` and `shfmt` own code lines)                            |
| Third-person docstring descriptions with params, returns, and exceptions        | `lint-docs` W4 heuristic and human review                                            |
| Semicolon, em/en dash, and label-then-colon bans                                | `lint-docs` W1-W3 warnings for grandfathered occurrences, human review for new prose |
| Everything else in this guide                                                   | Human review                                                                         |

---

## Precedence Note

When a rule in this guide conflicts with either source, or when you face a
choice neither source settles, resolve it as follows:

1. **Team preferences recorded in this guide win whenever they address a topic
   directly.** They represent this repository's hard-won conventions and take
   precedence over more generic guidance. The explicit overrides are: the total
   ban on semicolons in prose (Google permits a few constructions; we rewrite
   instead), the total ban on em and en dashes in prose (Google recommends em
   dashes; we rewrite instead), the ban on the label-then-colon sentence pattern
   (Google permits colons only with a complete sentence before them; we apply
   the stricter rule), and the recorded exceptions in item 5 below.
2. **The Google Developer Documentation Style Guide fills all gaps.** That
   includes grammar, formatting, accessibility, code examples, and terminology.
   The only exception is where following it would contradict the
   beginner-friendly, textbook-style spirit of the team guidelines.
3. **When in doubt, prioritize clarity and beginner-friendliness** over strict
   adherence to Google's conventions. If a choice is not obvious, keep Google's
   rule but feel free to note in context that the team preference may override
   it for a specific document.
4. **Departing from this guide is allowed when it clearly improves the
   content**, but stay consistent within the document and prefer to update this
   guide over accumulating undocumented exceptions.
5. **Recorded team exceptions.** First-person authorial voice (_my_, _I_) is
   kept where it exists (see [Tone & Voice](#tone--voice)). The punctuation bans
   and the two-space indentation rule apply to new content; pre-existing
   deviations are tracked as `lint-docs` warnings instead of errors.
