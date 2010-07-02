DbCompile
---------

Adds *rake db:compile* to your rails project tasks.  This task can be used to
compile views, functions, triggers, and more!

### Install

script/plugin install git://github.com/redhatcat/dbcompile.git

### Setup

Configuration is contained in one file, **RAILS_ROOT/db/compile.yml**.
In here, you describe the statement and dependencies.  You can fine an example
with comments [here](http://github.com/redhatcat/dbcompile/blob/master/example/compile.yml).

The SQL scripts themselves are places in several directories under **RAILS_ROOT/db**.

* RAILS_ROOT/db/functions contains function scripts.
* RAILS_ROOT/db/triggers contains trigger scripts.
* RAILS_ROOT/db/views contains view scripts.

All of these scripts, with the exception of views, should be self replacing,
e.g. you will want to use statements like *CREATE OR REPLACE FUNCTION*.

**Note on views**:  View scripts should be written as everything after the
*AS* keyword, i.e. write views as SELECTs.  DbCompile will magically wrap
the SELECT with CREATE OR REPLACE VIEW #{script_name} AS #{sql_source}.

### Adding new SQL contructs

If you want something beyond a function, trigger, or view, DbCompile is easy to
extend.  Simply create a new class that extends *DbCompile::Construct* and
require it in *lib/dbcompile/transaction.rb*.  See the source of
[lib/dbcompile/view.rb](http://github.com/redhatcat/dbcompile/blob/master/lib/dbcompile/view.rb)
and
[lib/dbcompile/construct.rb](http://github.com/redhatcat/dbcompile/blob/master/lib/dbcompile/construct.rb)
for reference.
