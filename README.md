# A simple knowledge sharing tool

This can be deployed on [OpenShift](http://openshift.com) as a quickstart. You
need a Ruby 1.9 application with MySQL cartridge added:

```
rhc app create kbase ruby-1.9 mysql-5.5 --from-code=https://github.com/mfojtik/kbase
```

For login, you need to have `GITHUB_CLIENT_ID` and `GITHUB_SECRET_ID` set via `rhc
env`.  You can get those two when you create a new GitHub application under your
profile.

This tool use beautiful <b>Padrino</b> framework, so no Rails(!). If you experience any
problems with this tool, I'm more than happy to accept pull request.

### License

"THE BEER-WARE LICENSE": As long as you retain this notice you can
do whatever you want with this stuff. If we meet some day, and you think this
stuff is worth it, you can buy me a beer in return.
