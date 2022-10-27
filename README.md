# Docker Web Testing
There are some funtionalities that cannot be tested with `headless` mode. For example, a file selection prompt.
With this docker you can run tests like native. By using tools like `xdotool` you can simulate the human interaction
that cannot be handled directly with `Selenium`.

For example, imagine that you have a fancy file uploader with cool and probably unnecessary javascript triggers (the user
clicks a button that do some stuff and then triggers the file prompt). With headless mode you have to `hack` the input 
type (by manually setting the filename). But doing this, you are not actually testing your application. You can't really 
test what happens when an user clicks your button. Your button could be totally broken passing all tests.

With this docker image you are actually rendering the webpage like native and you can test things like the mentioned above.
Most of you tests could be done with headless but other don't. This image is thought for these cases.

# Using it
The container is build for `aarch64`, `amd64` and `armhf`. Yes, you can run it even in a `raspberry pi`.

The minimal `Dockerfile` would looks like this:
```
FROM maxpowel/web-testing

COPY target/release/my_app my_app
CMD ["./my_app"]

```

If your application launches the driver by itself you can just build and run the container

```
docker buildx build -t my-test . --load
docker run --rm my-test
```

Remember that the driver locations are `/usr/bin/geckodriver` and `/usr/bin/chromedriver`. Firefox and chrome commands
are also available in the `$PATH`.

But if you dont want to take care about the driver, the container can run it before your application.

```
# To run chromedriver
docker run --rm -e CHROME=true my-test

# To run geckodriver
docker run --rm -e FIREFOX=true my-test

# Of course you can run both
docker run --rm -e CHROME=true -e FIREFOX=true my-test
```

# VNC

I case you want to run the vnc server, you only have to enable this option and expose the ports
```
docker run --rm -e FIREFOX=true -e VNC=true -p 5900:5900 my-test
```
Now take your favourite VNC client and connect to `localhost:5900`



# Building

Clone the repo and run `docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t web-testing .`
Select the platform you prefer


# Tools inside

xdotool
-------

You can simulate user interaction. `xdotool type --delay 100 Hello` to send the `Hello` keystrokes with a delay of 100 ms.
This would be useful for example to test how fast a user is typing. If you are doing a bot detection tool or just an application
that measures the user speed this will be very helpful for testing.

Also, anything that shows a prompt (like a file prompt) can be tested with it. You send the file location via keystrokes and then
push enter.

screenshot
----------

It basically takes a screenshot of the whole display by using `xwd` command. It is useful when you detect an error to take
a screenshot so you can debug better by knowing exactly what the browser rendered.

x11vnc
------

I case you need a more intensive debug, you can connect via VNC to you container to see en realtime what is happening there.

Locales
-------

Locales are provided so you can select the language of the system. Useful when you do multilanguage pages.

Geckodriver
-----------

Geckodriver and firefox are installed

Chromedriver
------------

Chromium and chromedriver are installed


# Other uses

This container is also nice for building bots or webscrapers. You can emulate human behaviour like native and spawn many instances. Kubernetes and ECS works great but you 
will need several IPs to do it "correctly".

I also tried to use it in `lambda` but unfortunately I could not make it work there. For some reason, `Selenium` cannot connect to the webdriver. I guess that some networking
configuration in lambda environment is causing this problem.

In case you want some "extra" help for you bot, you can always connect a video processing tool to VNC and infer things visually that would be very complicated to do analyzing the
html code. Or even captchas. [huggingface](https://huggingface.co/models) is a good starting point for that.
