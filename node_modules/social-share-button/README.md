# Social Share Buttons

![npm](https://img.shields.io/npm/v/social-share-button.svg?style=for-the-badge)
![npm](https://img.shields.io/github/workflow/status/firstandthird/social-share-button/Lint/main?label=Lint&style=for-the-badge)

Social sharing buttons for [Domodule](https://github.com/firstandthird/domodule).

## Installation

```sh
npm install social-share-button
```

_or_

```sh
yarn add social-share-button
```

## Usage

### HTML

```html
<body>
  <a data-module="SocialShareButton"
     data-module-text="No water in mars yet"
     data-module-tags="not,awesome"
     data-module-via="NASA"
     data-module-base-url="https://firstandthird.com/"
     data-module-net="twitter">Share on Twitter custom all</a>
</body>
```

### JavaScript

```js
import 'social-share-button';
```

It supports the following sharing methods:

* Email: `email`
* GPlus: `gplus`
* LinkedIn: `linkedin`
* Facebook: `facebook`
* Twitter: `twitter`
* Pinterest: `pinterest`
* Reddit: `reddit`

They're controlled with the `data-module-net` option.

## ShareUrl

**All** of the networks have a way to set the sharing url which is controlled via the `data-module-base-url` attribute. Should `data-module-relative` appear on the element, the URL would be based on the current one.

### Email Options

| Option     | Default       | Description                                                 |
|------------|---------------|--------------------------------------------------------|
| `subject` | `document.title` | Email's subject. |
| `body`    | `Check this out #url` | Note that `#url` will be replaced with `shareUrl` |

### LinkedIn Options

| Option     | Default       | Description                                                 |
|------------|---------------|--------------------------------------------------------|
| `text` | N/A | Linkedin's post text. |
| `title` | N/A | Linkedin's post title. |

### Twitter Options

| Option     | Default       | Description                                                 |
|------------|---------------|--------------------------------------------------------|
| `text` | `<meta property="twi:text" content="">` content's value | Twitter's post text. |
| `tags` | `<meta property="twi:hashtag" content="">` content's value | Hashtags |
| `via` | `<meta property="twi:author" content="">` content's value | Twitter's author |

### Facebook Options

Have in mind that facebook needs [OG tags](https://developers.facebook.com/docs/sharing/webmasters/) for the post to be formatted correctly.

| Option     | Default       | Description                                                 |
|------------|---------------|--------------------------------------------------------|
| `tag` | N/A | Post's tags. |
| `text` | N/A | Post's text. Note that due to facebook limitation's this is seen as a byline rather than as text. |

### Pinterest Options

| Option     | Default       | Description                                                 |
|------------|---------------|--------------------------------------------------------|
| `title` | N/A | Pin title |
| `media` | `<meta property="og:image" content="">` content's value | Pin image |

### Reddit Options

| Option     | Default       | Description                                                 |
|------------|---------------|--------------------------------------------------------|
| `title` | N/A | Reddit post title. |

---

<a href="https://firstandthird.com" target="_blank" rel="noreferrer"><img src="https://firstandthird.com/_static/ui/images/safari-pinned-tab-62813db097.svg" height="32" width="32" align="right"></a>

_A [First+Third](https://firstandthird.com) Project_
