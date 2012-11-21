DbCompile
---------

Adds *rake db:compile* to your rails project tasks.  This task can be used to
compile views, functions, triggers, and more!

### Install

script/plugin install git://github.com/redhatcat/dbcompile.git

### Setup

Configuration is contained in one file, **#{Rails.root}/db/compile.yml**.
In here, you describe the statement and dependencies.  You can fine an example
with comments [here](http://github.com/redhatcat/dbcompile/blob/master/example/compile.yml).

The SQL scripts themselves are places in several directories under **#{Rails.root}/db**.

* #{Rails.root}/db/functions contains function scripts.
* #{Rails.root}/db/triggers contains trigger scripts.
* #{Rails.root}/db/views contains view scripts.

All of these scripts, with the exception of views, should be self replacing,
e.g. you will want to use statements like *CREATE OR REPLACE FUNCTION*.

**Note on views**:  View scripts should be written as everything after the
*AS* keyword, i.e. write views as SELECTs.  DbCompile will magically wrap
the SELECT with CREATE OR REPLACE VIEW #{script_name} AS #{sql_source}.

### Adding new SQL constructs

If you want something beyond a function, trigger, or view, DbCompile is easy to
extend.  Simply create a new class that extends *DbCompile::Construct* and
require it in *lib/dbcompile/transaction.rb*.  See the source of
[lib/dbcompile/view.rb](http://github.com/redhatcat/dbcompile/blob/master/lib/dbcompile/view.rb)
and
[lib/dbcompile/construct.rb](http://github.com/redhatcat/dbcompile/blob/master/lib/dbcompile/construct.rb)
for reference.

### How the dependencies work

The dependencies of a contruct determine the order of (re)creation.  The
consequences of not stating dependencies in the case of a view:

* A view may fail being created entirely.
* A view may be created, then deleted by DROP CASCADE of another view it depends on.
