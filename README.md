# vodka-soda-ios

> Casual without compromise

## Set up

Grab the repo and install dependencies with [`Carthage`](https://github.com/Carthage):

```bash
> git clone https://github.com/tmm/vodka-soda.git
> cd vodka-soda
> brew update && brew install carthage
> carthage update --platform ios
```

Add environment variables to product scheme:

1. In Xcode, go to `Product` > `Scheme` > `Manage Schemes...`
2. Select `vodka-soda` and click `Edit...`
3. Go to `Run` > `Arguments`
4. Add your Client ID (`VODKA_SODA_CLIENT_ID` as key), Client Secret (`VODKA_SODA_CLIENT_SECRET`), and Base Url (`VODKA_SODA_BASE_URL` as key) to the Environment Variables.
