# HipchatSearcher

This is the command line tool for [hipchat](https://www.hipchat.com/).  
You will be able to search hipchat log more easily.  

## Installation

    $ gem install hipchat_searcher

## Prepare

* `hitchat_searcher` requires access token on [hipchat](https://www.hipchat.com/). so you visit [hipchat](https://www.hipchat.com/). login and get access token.
* if you get access token, execute command like this.

```
echo {access_token} > ~/.hps
```

## Usage

* Search word in all room

```
hps word
```

* Search word in specified room

```
hps word -r room-name
```

* Search word that user talks

```
hps word -u user-name
```

* Search word since target date

```
hps word -d 2014-01-01
```

* Search word in archived room

```
hps word -a
```

## Contributing

1. Fork it ( https://github.com/mgi166/hipchat_searcher/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
