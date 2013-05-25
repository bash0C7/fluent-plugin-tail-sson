# fluent-plugin-tail-sson

tail SSON support for Fluentd

## !!! CAUTION !!!

This plugin is not yet work in my production.
Please inspect yourself in your environment.

## SSON

Simple Sexp Object Notation

ref: http://www.slideshare.net/rejasupotaro/s-17005410/28

## Installation

Build gem to 'pkg/fluent-plugin-tail-sson-<VERSION>.gem' 

    bundle exec rake build

Install gem

    fluent-gem install --local  pkg/fluent-plugin-tail-sson-<version>.gem

## fluent.conf Example

````
<source>    
  type tail_sson
  path /tmp/fluent_parser_sson.log
  tag tail.sson
  format sson
</source>
````

- type tail_sson(required)
- format sson(required)

Other parameters : see http://docs.fluentd.org/ja/articles/in_tail

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
