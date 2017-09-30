### keybase-landing

[a trivial web page](https://kourier.keybase.pub) built with markdown and css to exercise the features of the
[Keybase filesystem](https://keybase.io/docs/kbfs)

#### keybase users may wish to fork and use this repository to publish their own verifiable content

1. clone
2. modify
3. deploy with `./bin/deploy-to-kbfs.sh KEYBASE_USERNAME --exclude '*.html' --delete-excluded`

The deploy script is a thin wrapper for rsync which duplicates the site to your keybase public folder. Obviously, you must have the keybase standaone app installed and logged in.

John, the upstream developer of the repository I forked for this, serves up this
nice stylesheet [over here](https://github.com/markdowncss/modest) and the rest
of this document is from him.

****

# Modest

A [markdown theme](https://markdowncss.github.io) that is rather modest.

## Installation

#### Through npm:

```
npm install --save markdown-modest
```

This theme integrates well with `rework-npm`, and has rework CSS available in the index.css file.

#### Clone the repo:

```
git clone https://github.com/markdowncss/modest.git
```

#### Development:

```
git clone https://github.com/markdowncss/modest.git && cd modest
npm install
gulp
```

## Usage

Link the file in your Markdown to HTML build process:

```html
<link rel="stylesheet" href="path/to/css/modest.css">
```

## License

MIT

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Crafted with <3 by [John Otander](http://johnotander.com) ([@4lpine](https://twitter.com/4lpine)).
