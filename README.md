# json2hat-helm

Helm chart for json2hat tool (To import `cncf/gitdm` `github_users.json` affiliations into LF SortingHat MariaDB database)


# Usage

Please provide secret values for each file in `./secrets/*.secret.example` saving it as `./secrets/*.secret` or specify them from the command line.

Please note that `vim` automatically adds new line to all text files, to remove it run `truncate -s -1` on a saved file.

List of secrets:
- File `secrets/SH_USER.secret` or --set `shUser=...` setup MariaDB admin user name.
- File `secrets/SH_HOST.env.secret` or --set `shHost=...` setup MariaDB host name.
- File `secrets/SH_PORT.secret` or --set `shPort=...` setup MariaDB port.
- File `secrets/SH_PASS.env.secret` or --set `shPass=...` setup MariaDB password.
- File `secrets/SH_DB.secret` or --set `shDB=...` setup MariaDB database.
- File `secrets/SYNC_URL.secret` or --set `syncUrl=...` setup sync URL address.
- File `secrets/ES_URL.env.secret` or --set `esUrl=...` setup ElasticSearch address.
- File `secrets/REPO_ACCESS.secret` or --set `repoAccess=...` setup access to DA API private repo address `https://username:oauth_key@github.com/LF-Engineering/dev-analytics-api`.

To install:
- `helm install json2hat ./json2hat-helm --set deployEnv=test`.

To upgrade:
- `helm upgrade json2hat ./json2hat-helm`.

You can install only selected templates, see `values.yaml` for detalis (refer to `skipXYZ` variables in comments), example:
- `helm install --dry-run --debug --generate-name ./json2hat-helm --set deployEnv=test,skipSecrets=1,skipCron=1,skipNamespace=1`.
- `helm install --dry-run --debug json2hat-debug ./json2hat-helm --set debugPod=1`.

Please note variables commented out in `./json2hat-helm/values.yaml`. You can either uncomment them or pass their values via `--set variable=name`.

Import company affiliations from cncf/devstats into GrimoireLab Sorting Hat database.

Other environment parameters:

- `SH_DSN`/`shDSN` - provides full database connect string, for example: `SH_DSN='shuser:shpassword@tcp(shhost:shport)/shdb?charset=utf8'`
- `SH_PROTO`/`shProto` - protocol, defaults to `tcp`.
- `SH_PARAMS`/`shParams` - additional parameters that can be specified via `?param1=value1&param2=value2&...&paramN=valueN`, defaults to `?charset=utf8`. You can use `SH_PARAMS='-'` to specify empty params.
- `SH_CLEANUP`/`shCleanup` - to cleanup existing company affiliations (delete from `organizations` and `enrollments` tables).
- `DRY_RUN`/`dryRun` - to execute in dry-run mode.
- `SKIP_BOTS`/`skipBots` - do not mark bot users.
- `NO_PROFILE_UPDATE`/`noProfileUpdate` - do not update profile data (country etc.), default is '1', so you need to clear it to enable profile updates.
- `REPLACE`/`replace` - for each profile/project first delete existing affiliations and then add. Default is '1', so you need to clear it to disable.
- `ONLY_GGH_USERNAME`/`onlyGGHUsername` - match usernames only for git or GitHub usernames, default is '1', clear it to match by all datasources usernames.
- `ONLY_GGH_NAME`/`onlyGGHName` - match names only for git or GitHub names. If you specify this, only names from git and GitHub will be matched.
- `NAME_MATCH`/`nameMatch` - specify how to match using name: 0 - do not match using name, 1 - match only when single hit, 2 - match on multiple hits, default is 1.
- `SH_TEST_CONNECT`/`shTestConnect` - set this variable to only test connection.
- `SH_REMOTE_JSON_PATH`/`shRemoteJSONPath` - remote affiliations JSON path, default: `https://github.com/cncf/devstats/raw/master/github_users.json`.
- `SH_REMOTE_YAML_PATH`/`shRemoteYAMLPath` - remote company acquisitions YAML path, default: `https://github.com/cncf/devstats/raw/master/companies.yaml`.

To shell into a SortingHat database pod (when you deployed with `--set debugPod=1`):

- `kubectl exec -it json2hat-debug -n json2hat -- /bin/bash`.
- `mysql -h $SH_HOST -u $SH_USER -p$SH_PASS $SH_DB`.
- `show tables;`.
