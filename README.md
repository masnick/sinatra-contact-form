# Sinatra Contact Form

A quick Sinatra app that can accept a contact form's POST, verify non-robotness with Google's reCAPTCHA, and send an email with SMTP.

## How it works

This app expects a web form to `POST` the following:

- `name`
- `email`
- `message`
- `g-recaptcha-response`, which is from a [Google reCAPTCHA](http://www.google.com/recaptcha/intro/index.html)

The app will then use the SMTP settings defined in `ENV` variables (see `.env-example`) to send you the form contents in an email.

On success (or captcha fail), users will be redirected to the URLs of your choice (also defined in `ENV` variables).

## Running in development

    shotgun app.rb -p 4567

You will need to save `.env-example` as `.env`, and replace the contents according to your own preferences.

## Deploying to production

I recommend Heroku. If you use them, you'll need to set some environment variables. You can do this from your `.env` file by running this command (Mac only):

    cat .env | sed "s/#.*//" | tr "\n" " " | pbcopy

You then type `heroku config:set ` and paste your clipboard, which will have all the environment variables in the right format for the `heroku` command. (I tried to do this all in one command but it didn't work.)

## Sending email

I recommend [Mandrill](http://mandrill.com) for sending email. Their free account can send 2,000 emails per month. But any transactional email delivery service that supports SMTP should work.

## License (MIT)

Copyright (c) 2015 Max Masnick

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
