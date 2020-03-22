import Vue from 'vue'
import App from './app.vue'
import router from './routes.js';
import store from './store.js';
import FunctionalCalendar from 'vue-functional-calendar';
import "font-awesome/css/font-awesome.min.css";

Vue.config.productionTip = false

Vue.prototype.$setFocus = (item) => {
  setTimeout(() => {
    item.focus();
  }, 50);
}

Vue.prototype.$setFocusByRefId = (refs, id) => {
  setTimeout(() => {
    refs[id][0].focus();
  }, 50);
}

Vue.component('VueFontawesome',
  require('vue-fontawesome-icon/VueFontawesome.vue').default
);

Vue.use(FunctionalCalendar);

window.onload = () => {
  new Vue({
    router,
    store,
    render: h => h(App),
  }).$mount('#app');
}
