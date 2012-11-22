# Create admin account
admin = User.create! name: "admin", email: "admin@admin.com", password: "bananas"
admin.update_attribute(:role, "admin")