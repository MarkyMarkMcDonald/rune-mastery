# rune-mastery
Comparing runes and masteries of your recent games vs pros

```bash
bundle install
ruby rune_comparison.rb
```

- [X] Display information for last 10 matches instead of just latest
- [X] Compare with top 5 pros instead of just top
- [X] Don't include pros with missing runes (outdated)
- [X] Say which pro we're comparing against
- ~~[ ] Include count of runes shared in RuneComparator#compare (instead of just which ones)~~
- [X] Include 'type' of rune as first class field (Quint, Mark, Glyph, Seal), ~~and bucket comparisons this way~~
- [ ] Cache SuccessfulGamesScraper (By Champion)
- [ ] Cache static api calls (Champion & Rune lookup)
