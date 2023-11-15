# Sharktopoda

![MBARI logo](Requirements/assets/logo-mbari-3b.png)

Sharktopoda is a video player for viewing, creating, and modifying rectangular localizations directly on video. It is designed to be integrated with other annotation and machine learning applications via a [UDP-based API](Requirements/UDP_Remote_Protocol.md).

This tool has been integrated with a number of MBARI's annotation tools including [vars-annotation](https://github.com/mbari-org/vars-annotation) and [vars-gridview](https://github.com/mbari-org/vars-gridview). To assist with integration with your own apps, there are the following pre-built libraries:

- Java: [vcr4j-remote](https://github.com/mbari-org/vcr4j/tree/master/vcr4j-remote). Available via [Maven](https://mvnrepository.com/artifact/org.mbari.vcr4j/vcr4j-remote)
- Python: [sharktopoda-client-py](https://github.com/kevinsbarnard/sharktopoda-client-py). Avaiable via [PyPI](https://pypi.org/project/sharktopoda-client/) and can be installed with `pip install sharktopoda-client`
