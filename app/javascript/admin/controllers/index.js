// Import and register all your controllers from the importmap under active_admin/controllers/*
import { application } from "admin/controllers/application"

// Eager load all controllers defined in the import map under active_admin/controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("admin/controllers", application)
