# Pub Crawl 🍻

A tool for fetching and exploring Dart packages published on 
[`pub`](https://pub.dev/).

[![Build Status](https://github.com/pq/pub_crawl/actions/workflows/dart.yml/badge.svg)](https://github.com/pq/pub_crawl/actions)


**Disclaimer:** This is not an officially supported Google product.

## Sample Applications

The kinds of investigations `pub_crawl` was designed to support include ones 
like:

* API Exploration - who's using this API and how?  How impactful would a 
  breaking change be?
* Lint Rule Testing - how does a new or existing rule perform on code in the
  wild?
* Language Experiment Testing - do existing packages continue to analyze cleanly
  when we enable an experiment?

## Usage

Pub crawl is run as a command-line tool.  Running from source is recommended as
that allows you to customize behavior in provided "hook" classes.

Supported commands are:

* `fetch` - fetch packages that match given criteria (for example, 
  `fetch --max 5 --criteria flutter,min_score:75` fetches 5 Flutter packages
  whose pub score is 75 or higher)
* `analyze` - analyze packages (✋ **DEPRECATED** -- consider 
  [`package:surveyor`][surveyor] instead)
* `lint` - a variation of `analyze` that makes it easy to lint packages with
  specified rules (for example, `lint --rules=await_only_futures,avoid_as`)
  (✋ **DEPRECATED** -- consider [`package:surveyor`][surveyor] instead)
* `clean` - deletes cached packages

For example,

```
dart bin/pub_crawl.dart fetch --max 10 --criteria flutter,min_score:75
dart bin/pub_crawl.dart analyze
```

fetches and then analyzes 10 Flutter packages whose pub score is 75 or higher.

### Filtering Fetches and Analyses with Criteria

Fetching and analysis can be directed by "criteria" that act as predicates,
filtering packages on qualities of interest.  `pub_crawl` defines a few criteria
out of the box:

* `flutter` - filters on packages that depend on Flutter
* `min_score:` - filters on overall pub package score (see the
  [pub scoring docs] for details)

Using criteria we can limit a `fetch` to Flutter packages that score 75 or
higher like this:

    dart bin/pub_crawl.dart --criteria flutter,min_score:75

If you want to define your own criteria, you can do so by adding a hook.

### Adding Your own Hooks

----------------------- 
🔈 **UPDATE:** hooks seemed like a good idea at the time but will likely go
away.  Consider [`package:surveyor`][surveyor] for custom analysis instead.

----------------------- 



You can customize various aspects of `pub_crawl` by adding your own logic to a
number of files that define hooks that are called during command execution.

```
lib/   
  hooks/
     criteria/
       analyze.dart
       fetch.dart
     visitors/
       dart.dart
       options.dart
       pubspec.dart
```

_(TODO: add custom criteria examples.)_

If you wanted to count declarations of methods of a given name, for example, you
could update `visitors.dart` like this:

```dart
class AstVisitor extends GeneralizingAstVisitor {
  int count = 0;

  void onVisitFinish() {
    print('Matched $count declarations');
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    if (node.name.name == 'debugFillProperties') {
      ++count;
    }
  }
}
```

More examples live in the [example](example) directory. 

## Related Work

See also [`package:surveyor`][surveyor], which explores a variation on pub_crawl
hooks to allow for custom "surveys" of Dart sources.

## Features and bugs

Please file feature requests, bugs and any feedback in the 
[issue tracker][tracker].

Thanks!

[tracker]: https://github.com/pq/pub_crawl/issues
[surveyor]: https://github.com/pq/surveyor
[pub scoring docs]: https://pub.dartlang.org/help#scoring
