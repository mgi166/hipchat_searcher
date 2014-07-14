# 1.0.0
### Feature
* Newer search result is output to the upstream
* Enable to search option `-e` named `deep-search`
   * Specify this option, search the log older than 75 recently
* Specify `date` option, also search the log with option `-e`
   * The reason is that refer to the `Bugfix`
* Refactor the code

### Bugfix
* Date option searches the date *until* you specify, Fix to search to the date of latest from you specified

# 0.0.3
### Feature
* Enable to search option `-A`, `-B`, `-C`, such as `grep`

### Bugfix
* Remove `#p` because `spec/lib/hipchat_searcher/searcher_spec.rb` was included

# 0.0.2
### Feature
* Enable to search Regexp on ignorecase.
* When specify -u option, It becomes searchable in the specified user.
* Specify multiple room name for using -r option.

### Bugfix
* Specify -r option for japanese room name.

# 0.0.1
* Initial release on 2014-06-22.
