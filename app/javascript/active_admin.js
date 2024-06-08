// Copy from https://github.com/activeadmin/activeadmin/blob/v4.0.0.beta7/app/javascript/active_admin.js
import "flowbite"
import Rails from "@rails/ujs"
import "active_admin/features/batch_actions"
import "active_admin/features/dark_mode_toggle"
import "active_admin/features/has_many"
import "active_admin/features/filters"
import "active_admin/features/main_menu"
import "active_admin/features/per_page"
// Customize
import "trix"
import "@rails/actiontext"
import "admin/controllers"

Rails.start()
