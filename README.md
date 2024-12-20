# Lifefay Docker Templates
Docker templates to quicky setup different Liferay environments.

These setups are designed to connect to a database hosted on the host machine (or alternatively, in a separate container).

Reference:
- https://liferay.atlassian.net/wiki/spaces/SUPPORT/pages/2093678703/Docker+Skill+Map+for+Customer+Support
- https://learn.liferay.com/w//dxp/installation-and-upgrades/installing-liferay/using-liferay-docker-images#using-liferay-docker-images

## Templates

* `00-archive`: Old versions (7.0, 7.1, 7.2) and tests
* `01-template-staging`: Base template for remote staging setup
* `202x.qx.x`: Main Template. Used for Quarterly Releases. It can be use to get a nightly image (master) by using `liferay/dxp:7.4.13.nightly`
* `7310-template`: 7.3 template
* `7413-template`: 7.4 template
* `remote-elastic-2servers`: 2 independent Liferay servers + 1 Remote ES instance

## Main features/configuration

- `deploy` dir can be found in `template_home/liferay/deploy`
- To install a hotfix, simply leave your zip file in `template_home/liferay/patching`
  - Avoid having multiple hotfixes at the same time, keep just one
- Captcha is disabled
- Session Auto Extend is enabled
- Logs are availabe in `template_home/logs`
- Prints useful information on startup, such as environment variables, properties or config files.
  - This is done by `template_home/scripts/pre-startup/log-liferay-config.sh`
- Sets Tomcat log level to info (`org.apache.level=INFO`) by modifying `tomcat/conf/logging.properties` to increase logging verbosity. 
  - This is done by `template_home/scripts/pre-configure/set-tomcat-level-info.sh`
- Persistent log levels can be easily configured by editing `template_home/liferay/files/tomcat/webapps/ROOT/WEB-INF/classes/META-INF/portal-log4j-ext.xml`
  - See https://help.liferay.com/hc/en-us/articles/360050830051-Adjusting-Log-Levels-to-persist-after-portal-restart 

See [Settings and configurations](#Settings-and-configurations) to know more about configuration optiones.

## How-To

Prerequisite: Define `MACHINE_HOST_IP` env variable, as explained in [DB Connection section](#db-connection) below

* Make a copy of the desired template in your machine
* Adjust `componse.yml`:
  * Change the liferay dxp image version at the beginning (find your image in https://hub.docker.com/r/liferay/dxp)
  * Change the name of the database in `LIFERAY_JDBC_PERIOD_DEFAULT_PERIOD_URL`
    * You may need to change the user and password as well, or even the database system. You may want to adapt the template to your needs, so it is prepared by default with your settings.
* Create the database
* (Optional) Check if the current settings fit your needs or you must adapt something. See [Settings and configurations](#Settings-and-configurations)
* Run `docker-compose up`

## DB Connection
An env variable needs to be defined for connecting with your local database system: `MACHINE_HOST_IP`. It is used in `componse.yml` files. 

It can be initialized like this in `~/.bashrc`:

    export MACHINE_HOST_IP=$(hostname -I | awk '{print $1}')

## Settings and configurations
Different settings and configurations are done using:

* Environment variables in `componse.yml` file
* `portal-ext.properties` placed in `$HOME/liferay/files`
* Configuration files placed in `$HOME/liferay/files/osgi`


## Adding other useful services

### Sending emails
Apart from adding the following services to the `componse.yml`, you will need to create a directory called `fakesmtp` in your `$HOME` (where `liferay` or `data` dirs are)

    mail:
        image: munkyboy/fakesmtp:latest
        privileged: true
        container_name: mail
        deploy:
            resources:
            limits:
                memory: 1G
            reservations:
                memory: 1G
        hostname: mail
        ports:
            - "25:25"
        volumes: 
            - ./fakesmtp:/var/mail
    mail-web:
        image: mjstewart/fakesmtp-web:1.3
        container_name: mail-web
        deploy:
            resources:
            limits:
                memory: 1G
            reservations:
                memory: 1G
        ports: 
            - "60500:8080"
        volumes:
            - ./fakesmtp:/var/mail
        environment:
            - EMAIL_INPUT_DIR_POLL_RATE_SECONDS=30
        depends_on:
            - mail

---

## Important note regarding empty dirs
Empty dirs have been added to the templates using this workaround: https://stackoverflow.com/a/932982. The following `.gitignonre` file has been added to those directories.

    # Ignore everything in this directory
    *
    # Except this file
    !.gitignore

Note that, if you plan to add files to any of those dirs, you may want to remove that `.gitignore` file.
