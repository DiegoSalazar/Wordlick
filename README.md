# Wordlick

Mobile optimized Ruby/Sinatra app for solving/generating words for Hanging With Friends.

[Demo.](http://wordlick.herokuapp.com/)

## To run locally

```bash
git clone -o origin git@github.com:DiegoSalazar/Wordlick.git
sudo gem install sinatra (if you don't have it)
cd wordlick
bundle
rackup
```

Point your browser to `localhost:9292`

***************************************************************
Notes: The word finding regex needs improvement. 
	For example: if we submit "e-e--" we shouldn't see a result that contains more than 2 "e" since we're looking for a word that only has 2 "e" 