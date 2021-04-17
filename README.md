# Tesseract_FFI

Welcome to Tesseract_FFI! 
This is a ruby wrapper to the Tesseract library. _Before installing this gem, make sure that Tesseract runs. For example, run the command_

```bash
$ tesseract --version
```

and under Linux, etc you should see something like
```bash
tesseract 4.1.1-rc2-25-g9707
 leptonica-1.78.0
  libgif 5.1.4 : libjpeg 8d (libjpeg-turbo 1.4.2) : libpng 1.2.54 : libtiff 4.0.6 : zlib 1.2.8 : libwebp 0.4.4 : libopenjp2 2.3.0
 Found AVX2
 Found AVX
 Found FMA
 Found SSE
 Found libarchive 3.1.2
```
Don't know about Windows, apart from the Windows Subsystem for Linux works really well! This also need Imagemagick to be installed (used for splitting pdfs).



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tesseract_ffi'
```

And then execute:
```bash
    $ bundle install
```
Or install it yourself as:
```bash
    $ gem install tesseract_ffi
```

## Usage
The fastest way to get going is to use the high-level functions that will probably suit most people , most of the time.

#### To convert an image to a string
```ruby
require 'tesseract_ffi'

TesseractFFI.to_text('my_image.png')
```
#### To convert an image to a searchable PDF file
```ruby
require 'tesseract_ffi'
TesseractFFI.to_pdf('my_image.png', 'output_file')
```

## Languages
When the default 'recognition  of English' is not suitable, you can change it. The abreviations used for some common European languages are

* deu - German
* eng - English
* fra - French
* ita - Italian
* nld - Dutch
* por - Portuguese
* spa - Spanish

but Tesseract itself supports many, many languages including but not limited to chi_sim (Chinese simplified), chi_tra (Chinese traditional), chr (Cherokee), cym (Welsh), frk (Frankish), frm (French, Middle, ca.1400-1600). Just ensure that you have the corresponding Tesseract language recognition libraries installed. The best way to confirm this is directly from the command line. For example, to ensure that French recognition files are available to tesseract, type this command to recognise a test image in French
```bash
tesseract imagename.png  mytext -l fra
```
To call from within a ruby file, the following snippet should work for an image in German:
```ruby
require 'tesseract_ffi'

TesseractFFI.to_text('my_image.png', 'deu')
```
or by creating Ruby objects:

```ruby
require 'tesseract_ffi'
tess = TesseractFFI::Tesseract.new(
      language:'fra', 
      file_name: 'test/images/bonjour.png')
tess.recognize
text = tess.utf8_text
```

## To Generate HOCR 
Wikipedia says HOCR 'is an open standard of data representation for formatted text 
obtained from optical character recognition (OCR)'.  Tesseract can produce it and generate the bounding boxes of the words, the lines, the paragraphs on a page.

```ruby
require 'tesseract_ffi'
tess = TesseractFFI::Tesseract.new( 
      file_name: 'test/images/4words.png', 
      source_resolution:96)
tess.recognize
text = tess.hocr_text
```

```xml
<div class='ocr_page' id='page_18' title='image ""; bbox 0 0 341 17; ppageno 17'>
   <div class='ocr_carea' id='block_18_1' title="bbox 0 0 341 17">
    <p class='ocr_par' id='par_18_1' lang='eng' title="bbox 0 0 341 17">
     <span class='ocr_line' id='line_18_1' title="bbox 0 0 341 17; baseline -0.012 -1; x_size 16; x_descenders 4; x_ascenders 4">
      <span class='ocrx_word' id='word_18_1' title='bbox 0 4 49 17; x_wconf 92'>Name</span>
      <span class='ocrx_word' id='word_18_2' title='bbox 54 4 94 17; x_wconf 90'>Arial</span>
      <span class='ocrx_word' id='word_18_3' title='bbox 237 0 296 15; x_wconf 90'>Century</span>
      <span class='ocrx_word' id='word_18_4' title='bbox 302 0 341 12; x_wconf 90'>Peter</span>
     </span>
    </p>
   </div>
  </div>
```

## Recognise Part of an Image
```ruby
require 'tesseract_ffi'
tess = TesseractFFI::Tesseract.new( 
      file_name: 'test/images/4words.png')

# tess.recognize_rectangle(x,y,w,h)
tess.recognize_rectangle(300, 0, 41, 15)
text = tess.utf8_text
# => "Peter"

```

## General Structure 

Create a TesseractFFI::Tesseract object specifying the image file, the language(s) and, optionally the source resolution (dpi of the image) and the OCR Engine Mode, OEM. The default is to use the latest mode, which uses a neural network for the recognition. For some purposes, such as typeface/font recognition, it can be desirable to use the legacy mode even though the recognition is not usually as good.

```ruby
require 'tesseract_ffi'
tess = TesseractFFI::Tesseract.new( 
      file_name: 'test/images/4words.png', 
      source_resolution:96)

```
Then call Tesseract.setup with the desired methods in a block.

```ruby

tess.setup do
  tess.set_rectangle(300, 0, 40, 20)
  tess.ocr
  puts tess.utf8_text
  # => Peter
  tess.set_rectangle(0, 0, 340, 17)
  tess.ocr
  puts tess.utf8_text
  # => Name Arial Century Peter
end

```


## Low Level Calls

If you look under the hood, there are intermediate ruby methods that do most things, and some very low level functions that make calls to the C-API of Tesseract using the wonderful FFI library. The low level functions give alarming error messages and often stack dump if called in the wrong order, so they are not for the feint of heart. But if your screen allows to scroll back 1000 lines, you can usually see where the call to Tesseract went wrong. This gem aims to hide the complexity of the direct calls to the C library. The examples directory includes a couple of files that show the way to proceed at the different levels of complexity and the tests show more usage.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dverrier/tesseract_ffi. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/dverrier/tesseract_ffi/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Tesseract_FFI project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/tessy/blob/master/CODE_OF_CONDUCT.md).
