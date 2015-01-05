# Optimize & Secure PHP.INI for [php-fpm](http://www.php.net/manual/en/install.fpm.php)

## Introduction 

This script that **optimize and secure** your PHP configuration. 

Displaying error only enabled on Development enviroment, in production it's disabled.
Disabling the errors and limiting it only to `Information` will limit its vulnerabilities such as:

 + PHP scripts path disclosure;
 
 + Displaying Enabled/Disabled php extensions ;

 
 For more info about PHP path disclosure vulnerability or [path traversal exploit](https://secure.wikimedia.org/wikipedia/en/wiki/Path_traversal)
 
## Altered PHP settings

 The following settings are altered:
 
  1. **Error logging**:
  	 **production** > `syslog`; 
     **development** > `web client`;
     
     
  2. **PHP exposition**: prevents exposing if you're running PHP and/or which version.
           
  3. **memory limit**: a generous **512 MB**.
  
  4. **POST** and **upload** maximum sizes.
     
  6. **cgi.fix\_pathinfo** set to **0**.
     
  7. Disallow `fopen` or `include` to open files specified through a URI.
     
  8. disallow for manipulation of
     [cookies](http://www.owasp.org/index.php/HTTPOnly "OWASP on
     HttpOnly") through the DOM.
     
  9. Setup additional entropy for session token generation 
     using the hardware random number generator `/dev/urandom`. 
     This requires PHP 5.3 or later.
     
## Installation and Usage
 
To use this script(s) do the following:
 
  1. Clone the git repo.

     `git clone https://github.com/azoughbi/php-ini-optimize.git`
    
  2. Run the shell script `php_optimize`. 
  	 It has three arguments `php_optimize -p [-d] -m 2G /path/to/php.ini`:
     
     a) the first argument:
        either `-p` to optimize **production** environment
     	or `-d` to optimize **development** enviroment.
     
     b) `-m 2G` specifies the memory limit for PHP. By default is 512M.
     
     c) The last argument specifies the full path of `php.ini` file. 
     	if running from inside `/etc/php5/fpm` no need to specify the path.
        
        
### Usage Examples
  
  1. Optimize production site, running the script on the current directory:
      
	 `php_optimize -p`
      
  2. Optimize development site, running the script on the current directory:
  
	 `php_optimize -d`
     
     
  3. Optimize production site with [PHP FPM](http://php-fpm.org),
     from outside `/etc/php5/fpm` directory:
     
     `php_optimize -p /etc/php5/fpm/php.ini`

  4. Optimize a production site with [PHP FPM](http://php-fpm.org),
     from outside `/etc/php5/fpm` directory and set the memory limit to 2G:
     
	 `php_optimize -p -m 2G /etc/php5/fpm/php.ini`