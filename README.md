# WITW

> 🚧 This app is still in alpha development and we don't recommend using it yet.

## Development server

The code for the server is located in the [`backend`](./backend) directory.

### 1. Install dependencies

1. Install [Postgres.app](https://postgresapp.com/) and follow the [instructions](https://postgresapp.com/documentation/install.html) to add it to your path.

2. Set a `virtualenv` (optional)

3. Install the OS & pip dependencies.

```sh
# On MacOS with brew
brew install gdal libgeoip

# On Ubuntu
sudo add-apt-repository ppa:ubuntugis/ppa
sudo apt-get update
sudo apt-get install libgeoip-dev libgdal-dev gdal-bin
sudo apt-get install postgresql-12-postgis-3

# On everything
pip install -r requirements-test.txt
pip install -r requirements.txt
```

**Running on M1**
To run successfully on M1, set the following env vars

```sh
export GDAL_LIBRARY_PATH=/opt/homebrew/lib/libgdal.dylib
export GEOS_LIBRARY_PATH=/opt/homebrew/lib/libgeos_c.dylib
```

### 2. Create database and start backend

```sh
psql
CREATE DATABASE whereintheworld;
CREATE USER whereintheworld WITH PASSWORD 'whereintheworld';
ALTER ROLE whereintheworld SUPERUSER;
```

**Migrate the database

```sh
python manage.py migrate
python manage.py cities --import=all
```

### 3. Get Google Oauth configs

<https://console.cloud.google.com/apis/credentials>

### 3. Start the app

The code for the frontend is located in the [`src`](./src) directory. You can start the entire app (frontend & backend) as follows:

```sh
yarn
./bin/start
```

The server is now running at [`http://localhost:8000/`](http://localhost:8000/). **Warning:** Don't visit `localhost:3000` as the raw frontend will not work as expected.

## Docker environment

### Build and push Docker images

To build new Docker image, from the root of repository run.

```sh
yarn image:build
```

Image name is defined in `package.json` file as `image` attribute. Image tag will be the same as application version from `package.json`

To bump the version, from the root of repository, execute

```sh
yarn version --major | --minor | --patch
```

To push the image to the Docker registry, from the root of the project execute

```sh
yarn image:push
```

### Run the image locally

Docker compose definition located under `./contrib/docker` folder
In order to deploy image on local docker environment from the root of this repo run:

```sh
yarn dev
```

### Deploy using Helm

Helm chart is located under `./contrib/helm/whereintheworld` folder, in order to install it on existing Kubernetes cluster simply run the following command from root of this repo

```sh
helm upgrade -i whereintheworld ./contrib/helm/whereintheworld --wait
```

## Future improvements

### Codebase

* Remove dependency on Google Oauth2 in order to enable local deployments
* Some of the settings like database name and port are hardcoded in `settings.py` file
* Linter fails during Sentry initialization. Disable Sentry for local tests?
* Application require `SUPERUSER` database permissions on schema. This leads to some ugly hacks in order to run it on vanila Postgres docker image.

### Helm chart

* External Postgres hasn't been tested
* Generate proper documentation from `values.yaml` file
* Improve autoscaling
* Add Helm unittests
* Add integration tests for all possible cloud providers
* Add pre-install hook to seed cities data. Seeding script is very slow though. Use volume snapshot to preseed the data, may be?
