# Tesseract_FFI

Welcome to Tesseract_FFI! 
This is a ruby wrapper to the Tesseract library. Before installing this gem, make sure that Tesseract runs. For example, run the command 

```tesseract --version
```

and under Linux, etc you should see something like
```tesseract 4.1.1-rc2-25-g9707
 leptonica-1.78.0
  libgif 5.1.4 : libjpeg 8d (libjpeg-turbo 1.4.2) : libpng 1.2.54 : libtiff 4.0.6 : zlib 1.2.8 : libwebp 0.4.4 : libopenjp2 2.3.0
 Found AVX2
 Found AVX
 Found FMA
 Found SSE
 Found libarchive 3.1.2
```
Don't know about Windows, apart from the Windows Subsystem for Linux works really well!



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tesseract_ffi'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install tesseract_ffi

## Usage
The fastest way to get going is to use the high-level functions that will probably suit most people , most of the time.
```ruby
require 'tesseract_ffi'

TesseractFFI.to_text('my_image.png')
```
or 
```ruby
gem 'tesseract_ffi'
TesseractFFI.to_pdf('my_image.png', 'output_file')
```

If you look under the hood, there are lots of intermediate ruby methods that do most things, and some very low level functions that make calls to the C-API of Tesseract using the wonderful FFI library. The low level functions give alarming error messages and often stack dump if called in the wrong order, so they are not for the feint of heart. But if your screen allows to scroll back 1000 lines, you can usually see where the call to Tesseract went wrong.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dverrier/tesseract_ffi. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/dverrier/tesseract_ffi/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Tessy project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/tessy/blob/master/CODE_OF_CONDUCT.md).
