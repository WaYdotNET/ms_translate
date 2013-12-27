# MsTranslate
The library is a simple API in Ruby for Microsoft Translator V2

The Microsoft Translator services can be used in web or client
applications to perform language translation operations. The services
support users who are not familiar with the default language of a page
or application, or those desiring to communicate with people of a
different language group.

## Installation

Add this line to your application's Gemfile:

    gem 'ms_translate'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ms_translate

## Usage

first step set your appId

    $ MsTranslate::Api.appId = 'MyRealAppId'

traNslate method:

    $ MsTranslate::Api.translate('Hello World!)
    $ => Ciao, Mondo!

## Method not implemented

1. Microsoft.Translator.AddTranslation Method
2. Microsoft.Translator.AddTranslationArray Method

## Test

You need to insert your appId into

    # File 'spec/lib/ms_translate/api_spec.rb'
    @api_real =  'INSERT_YOUR_APPID'

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Author

[![endorse](http://api.coderwall.com/waydotnet/endorsecount.png)](http://coderwall.com/waydotnet)

WaYdotNET, you can follow me on twitter [@WaYdotNET](http://twitter.com/WaYdotNET) or take a look at my site [waydotnet.com](http://www.waydotnet.com)

## Copyright

Copyright (C) 2012 Carlo Bertini - [@WaYdotNET](http://twitter.com/WaYdotNET)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the “Software”), to deal in the Software without restriction, including without
limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/WaYdotNET/ms_translate/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

