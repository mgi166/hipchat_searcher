# HipchatSearcher

[![Build Status](https://travis-ci.org/mgi166/hipchat_searcher.svg?branch=master)](https://travis-ci.org/mgi166/hipchat_searcher)
[![Coverage Status](https://coveralls.io/repos/mgi166/hipchat_searcher/badge.png?branch=master)](https://coveralls.io/r/mgi166/hipchat_searcher?branch=master)
[![Code Climate](https://codeclimate.com/github/mgi166/hipchat_searcher.png)](https://codeclimate.com/github/mgi166/hipchat_searcher)

This is the command line tool for [hipchat](https://www.hipchat.com/).  
You will be able to search hipchat log more easily.  

## Installation

    $ gem install hipchat_searcher

## Prepare

* `hitchat_searcher` requires access token on [hipchat](https://www.hipchat.com/). so you visit [hipchat](https://www.hipchat.com/), login and get access token.
* If you get access token, execute command like this.

```
echo {access_token} > ~/.hps
```

## Usage

`hipchat_searcher` search for a regular expression the words that you specify.  
In the specifications of the [hipchat api](https://www.hipchat.com/docs/apiv2/), `hipchat_searcher` search of the upcoming 100 comments.

* Search the words in all room
   * But it searches ALL the room that user know, so there may be heavy.

```
hps word
```

* Search the words in specified room

```
hps word -r room-name
```

* Search the words that specified user talks

```
hps word -u user-name
```

* Search the words since target date

```
hps word -d 2014-01-01
```

* Search the words in archived room

```
hps word -a
```

## Contributing

1. Fork it ( https://github.com/mgi166/hipchat_searcher/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
