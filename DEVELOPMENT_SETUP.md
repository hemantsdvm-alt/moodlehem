# Development Setup Guide

This guide describes how to set up this Moodle repository for local development.

## Prerequisites

- PHP (with extensions: gd, intl, xml, curl, zip, mbstring, mysqli/pgsql)
- MariaDB or MySQL
- Node.js & npm

## Installation Steps

1.  **Install Frontend Dependencies**
    ```bash
    npm install
    ```

2.  **Create Data Directory**
    Create a directory for Moodle data (outside the web root if possible, or secured):
    ```bash
    mkdir -p moodledata
    chmod 777 moodledata
    ```

3.  **Install Moodle (CLI)**
    Use the CLI installer to configure Moodle and the database. Adjust the parameters as needed.
    ```bash
    php admin/cli/install.php \
    --wwwroot="http://localhost:3000" \
    --dataroot="$(pwd)/moodledata" \
    --dbtype="mariadb" \
    --dbhost="localhost" \
    --dbname="moodle" \
    --dbuser="moodle" \
    --dbpass="moodle" \
    --fullname="Moodle Dev Site" \
    --shortname="MoodleDev" \
    --adminpass="Admin123!" \
    --adminemail="admin@example.com" \
    --non-interactive \
    --agree-license \
    --allow-unstable
    ```

    **Note:** This creates `config.php` in the root. If serving from `public/`, create a symlink:
    ```bash
    ln -s ../config.php public/config.php
    ```

4.  **Configure Development Settings**
    Add the following to your `config.php` (before `require_once` at the end) to enable debugging and disable caching:
    ```php
    // Development settings
    @error_reporting(E_ALL);
    @ini_set('display_errors', '1');
    $CFG->debug = (E_ALL | E_STRICT);
    $CFG->debugdisplay = 1;
    $CFG->debug_developer_use_pretty_exceptions = true;
    $CFG->themedesignermode = true;
    $CFG->cachejs = false;
    $CFG->cachetemplates = false;
    $CFG->langstringcache = false;
    ```

## Running the Development Server

### Quick Start

We have provided a script to start all necessary services for you.

```bash
./start_dev.sh
```

This will:
1.  Install frontend dependencies if missing.
2.  Start the Grunt watcher (for CSS/JS changes).
3.  Start the PHP web server at [http://localhost:3000](http://localhost:3000).

### Manual Start

If you prefer to run commands manually:

1.  **Start Frontend Watcher**
    This will watch for changes in SCSS and JS files and recompile them.
    ```bash
    npx grunt watch
    ```

2.  **Start Web Server**
    Start the PHP built-in server pointing to the `public` directory.
    ```bash
    php -S 0.0.0.0:3000 -t public
    ```

3.  **Access the Site**
    Open [http://localhost:3000](http://localhost:3000) in your browser.

## Default Credentials

If you used the installation command above, your credentials are:

*   **Admin Username:** `admin` (default)
*   **Admin Password:** `Admin123!`
*   **Database User:** `moodle`
*   **Database Password:** `moodle`
