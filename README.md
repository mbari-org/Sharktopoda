# Sharktopoda

![MBARI logo](Requirements/assets/logo-mbari-3b.png)

Sharktopoda is a Mac video player application for viewing, creating, and modifying rectangular localizations directly on video. It is designed to interact with annotation and machine learning applications via a [UDP-based API](Requirements/UDP_Remote_Protocol.md).

It has been integrated with a number of MBARI's annotation tools including [vars-annotation](https://github.com/mbari-org/vars-annotation) and [vars-gridview](https://github.com/mbari-org/vars-gridview). To assist with integration with your own apps, there are the following pre-built libraries:

- Java: [vcr4j-remote](https://github.com/mbari-org/vcr4j/tree/master/vcr4j-remote). Available via [Maven](https://mvnrepository.com/artifact/org.mbari.vcr4j/vcr4j-remote)
- Python: [sharktopoda-client-py](https://github.com/kevinsbarnard/sharktopoda-client-py). Available via [PyPI](https://pypi.org/project/sharktopoda-client/) and can be installed with `pip install sharktopoda-client`

![Screen shot](Requirements/assets/SharkShot.png)
