const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './app/components/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
        fontawesome: [ 'FontAwesome'],
      },
      colors: {
        'corporate-50': '#f4fbea',
        'corporate-100': '#e7f5d2',
        'corporate-200': '#ceecaa',
        'corporate-300': '#afde78',
        'corporate-400': '#89ca42',
        'corporate-500': '#72b32f',
        'corporate-600': '#568e22',
        'corporate-700': '#436d1e',
        'corporate-800': '#38571d',
        'corporate-900': '#314a1d',
        'corporate-950': '#17280b',
        'ruby': '#cc342d',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
