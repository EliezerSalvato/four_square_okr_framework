import Vue from 'vue'
import VueRouter from 'vue-router';

Vue.use(VueRouter);

import OkrBoard from './views/index.vue';
import Projects from './views/projects.vue';
import ProjectSteps from './views/project_steps.vue';

const router = new VueRouter({
  mode: 'history',
  routes: [
    { path: '/', component: OkrBoard },
    { path: '/projects', component: Projects },
    { path: '/project_steps', component: ProjectSteps }
  ]
});

export default router;
