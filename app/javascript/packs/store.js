import Vue from "vue";
import Vuex from "vuex";
import { api } from "./services.js";

Vue.use(Vuex);

export default new Vuex.Store({
  strict: false,
  state: {
    showMessageError: false,
    textMessageError: null,
    showMessageSuccess: false,
    textMessageSuccess: null,
    projectStepSaved: true,
    selectedStep: null,
    newProjectStep: false,
    priorities: null,
    confidences: null,
    nextProjects: null,
    healthMetrics: null
  },
  mutations: {
    UPDATE_SHOW_SAVE_ERROR(state, show) {
      state.showMessageError = show;
    },
    UPDATE_SHOW_SAVE_CONFIRMATION(state, show) {
      state.showMessageSuccess = show;
    },
    UPDATE_TEXT_MESSAGE_ERROR(state, text) {
      state.textMessageError = text;
    },
    UPDATE_TEXT_MESSAGE_SUCCESS(state, text) {
      state.textMessageSuccess = text;
    },
    UPDATE_PROJECT_STEP_SAVED(state, saved) {
      state.projectStepSaved = saved;
    },
    UPDATE_SELECTED_STEP(state, selectedStep) {
      state.selectedStep = selectedStep;
    },
    UPDATE_NEW_PROJECT_STEP(state, newProjectStep) {
      state.newProjectStep = newProjectStep;
    },
    UPDATE_PRIORITIES(state, priorities) {
      state.priorities = priorities;
    },
    UPDATE_CONFIDENCES(state, confidences) {
      state.confidences = confidences;
    },
    UPDATE_NEXT_PROJECTS(state, nextProjects) {
      state.nextProjects = nextProjects;
    },
    UPDATE_HEALTH_METRICS(state, healthMetrics) {
      state.healthMetrics = healthMetrics;
    }
  },
  actions: {
    setShowMessageError(context, payload) {
      let show = payload;

      if (typeof payload != "boolean") {
        show = payload.show;
        context.commit("UPDATE_TEXT_MESSAGE_ERROR", payload.text);
      } else {
        context.commit("UPDATE_TEXT_MESSAGE_ERROR", null);
      }

      context.commit("UPDATE_SHOW_SAVE_CONFIRMATION", false);
      context.commit("UPDATE_SHOW_SAVE_ERROR", show);
    },
    setShowMessageSuccess(context, payload) {
      let show = payload;

      if (typeof payload != "boolean") {
        show = payload.show;
        context.commit("UPDATE_TEXT_MESSAGE_SUCCESS", payload.text);
      } else {
        context.commit("UPDATE_TEXT_MESSAGE_SUCCESS", null);
      }

      context.commit("UPDATE_SHOW_SAVE_ERROR", false);
      context.commit("UPDATE_SHOW_SAVE_CONFIRMATION", show);
    },
    hideMessages(context) {
      context.commit("UPDATE_SHOW_SAVE_ERROR", false);
      context.commit("UPDATE_SHOW_SAVE_CONFIRMATION", false);
    },
    projectStepChanged(context, changed) {
      context.commit("UPDATE_PROJECT_STEP_SAVED", !changed);
    },
    setSelectedStep(context, selectedStep) {
      context.commit("UPDATE_SELECTED_STEP", selectedStep);
    },
    setNewProjectStep(context, newProjectStep) {
      context.commit("UPDATE_NEW_PROJECT_STEP", newProjectStep);
    },
    updateItems(context, payload) {
      const type = payload.type;
      const items = payload.items;

      switch (type) {
        case 'priorities': context.commit("UPDATE_PRIORITIES", items); break;
        case 'confidences': context.commit("UPDATE_CONFIDENCES", items); break;
        case 'next_projects': context.commit("UPDATE_NEXT_PROJECTS", items); break;
        case 'health_metrics': context.commit("UPDATE_HEALTH_METRICS", items); break;
      }
    },
    async saveProjectStep(context) {
      const selectedStep = context.state.selectedStep;
      const items = {
        id: selectedStep.id,
        project_step: {
          ...selectedStep,
          priorities_attributes: context.state.priorities,
          confidences_attributes: context.state.confidences,
          next_projects_attributes: context.state.nextProjects,
          health_metrics_attributes: context.state.healthMetrics
        }
      };

      const response = await api.post("project_steps/create_or_update", items);

      if (response.data.status === "ok") {
        selectedStep.id = response.data.id;
        context.dispatch("setSelectedStep", selectedStep);
        context.commit("UPDATE_PROJECT_STEP_SAVED", true);
        context.dispatch("setShowMessageSuccess", true);
      } else {
        context.dispatch("setShowMessageError", { show: true, text: response.data.error });
      }

      return response;
    }
  }
});
