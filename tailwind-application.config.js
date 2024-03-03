const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/javascript/**/*.js',
    './app/packages/*/helpers/**/*.rb',
    './app/packages/*/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        'corporate-50': '#0ab360',
        'corporate-100': '#b0ffcd',
        'corporate-200': '#80ffb3',
        'corporate-300': '#50ff9b',
        'corporate-400': '#28ff88',
        'corporate-500': '#18e676',
        'corporate-600': '#0ab360',
        'corporate-700': '#008048',
        'corporate-800': '#004d25',
        'corporate-900': '#001b07',
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
