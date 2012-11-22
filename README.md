# GroupMaker

A simple app to vote on and select members for groups.

Designed and built for use @ [Dev Bootcamp](http://devbootcamp.com/).

---

### Installation

```bash
git clone git://github.com/openspectrum/group_maker.git
cd group_maker
bundle
bundle exec rake db:migrate
```

**Seed Data**

Change `db/seeds.rb` to set the default admin account for the app.

### Demo

To quickly generate demo data, run `bundle exec rake demo:build:all`.  This will populate the database with users, sample projects, and choices.  Browse `lib/tasks/demo.rake` to see the details.

If you login as the admin user, you have control over the flow of the app.  The `/admin` page gives you the ability to allow/disallow voting and choosing of projects, as well as other options.

To run the group generator algorithm, press the `Make Groups` button in `/admin/index` or run `GroupList.generate!` from the console.
