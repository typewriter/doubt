# doubt
API Server and Google Chrome Extension to Classify Web Pages

## Example (Chrome extension)

![chromeextension](https://user-images.githubusercontent.com/1283492/60382204-d0c93880-9a9a-11e9-8828-9b5b72206cef.gif)

## Installation

### Chrome extension

1. Open `chrome://extensions/`
2. Enable developer mode
3. Load chrome-extension directory with "Load unpacked"

### Server (optional)

1. Install MeCab (for separating words in Japanese with spaces)
2. Run `bundle install`
3. Run `bundle exec unicorn -E production -c unicorn.conf -D &` (start as daemon)

## Usage

1. Click on the icon to learn the likes and dislikes of the page you are viewing.
2. When the page is opened, the icon changes according to the learning result.

Icon|Meaning
--|--
![icon-like](https://user-images.githubusercontent.com/1283492/60753242-68360a80-a00a-11e9-9c22-2bda0282a60c.png)|Like
![icon-dislike](https://user-images.githubusercontent.com/1283492/60753248-6d935500-a00a-11e9-9fbf-6c635207667f.png)|Dislike
![icon](https://user-images.githubusercontent.com/1283492/60753296-09bd5c00-a00b-11e9-82f8-5a779d173a24.png)|In progress or unknown (unlearned or pages requiring authentication)


## Notice

- The URLs of all the displayed pages will be sent to the server (content will not be sent).
- A learning result is generated for each key. You can share your learning results with others using the same key.

