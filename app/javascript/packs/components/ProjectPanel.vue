<template>
  <div class="header">
    <label for="project">Project:</label>
    <select v-model="selected.project_id" @change="getLastProjectStepByParams" class="project" name="project">
      <option v-for="project in projects" :key="project.id" :value="project.id">
        {{project.name}}
      </option>
    </select>
    <label for="year">Year:</label>
    <input type="number" class="year" v-model="selected.year" @blur="getLastProjectStepByParams" name="year"
      onKeyDown="if (!isNaN(Number(event.key)) && this.value.length === 4) return false;"
    >
    <label for="quarter">Quarter:</label>
    <select v-model="selected.quarter" @change="getLastProjectStepByParams" class="quarter" name="quarter">
      <option
        v-for="quarter in quarters"
        :key="quarter"
        :value="quarter"
        :selected="quarter == selected.quarter ? 'selected' : ''"
      >
        {{quarter}}
      </option>
    </select>
    <label for="start_at">Start At:</label>
    <input v-if="!editDate" type="text" class="disabled-date" ref="start_at_disabled" disabled />
    <FunctionalCalendar
      v-if="editDate"
      name="start_at"
      :is-date-picker="true"
      :sundayStart="true"
      :isModal="true"
      ref="start_at"
      @choseDay="changeStartAt"
    ></FunctionalCalendar>
    <label for="end_at">End At:</label>
    <input v-if="!editDate" type="text" class="disabled-date" ref="end_at_disabled" disabled />
    <FunctionalCalendar
      v-if="editDate"
      name="end_at"
      :is-date-picker="true"
      :sundayStart="true"
      :isModal="true"
      :disabled="true"
      ref="end_at"
      @choseDay="changeEndAt"
    ></FunctionalCalendar>
    <a class="btn btn-circle" :class="{ 'btn-disabled': prevBtnDisabled }" @click.prevent="prevPrejectStep">
      <vue-fontawesome icon="arrow-left" size="1.2" />
    </a>
    <a class="btn btn-circle" :class="{ 'btn-disabled': nextBtnDisabled }" @click.prevent="nextPrejectStep">
      <vue-fontawesome icon="arrow-right" size="1.2" />
    </a>
    <input v-if="projectStepSaved" type="button" class="btn" @click="newBoard" value="New" />
    <input v-else type="button" class="btn" @click="save" value="Save" />
  </div>
</template>

<script>
  import moment from "moment";
  import { api } from "../services.js";
  import { mapState, mapActions } from "vuex";

  export default {
    name: "ProjectPanel",
    props: {
      refBoards: Object
    },
    data() {
      return {
        projects: null,
        selected: {},
        editDate: false,
        prevProjectStepId: null,
        nextProjectStepId: null,
        quarters: ["Q1", "Q2", "Q3", "Q4"]
      }
    },
    computed: {
      ...mapState(["projectStepSaved", "selectedStep", "newProjectStep"]),
      prevBtnDisabled() {
        return (this.prevProjectStepId == null);
      },
      nextBtnDisabled() {
        return (this.nextProjectStepId == null);
      }
    },
    methods: {
      ...mapActions(["projectStepChanged", "setSelectedStep", "saveProjectStep", "setNewProjectStep"]),
      getProjects() {
        return api.get("projects").then(response => {
          this.projects = response.data;
        });
      },
      setSelectedProjectStep(project_step) {
        if (project_step === null) {
          this.selected.id = null;
        } else {
          this.selected = {
            id: project_step.id,
            project_id: project_step.project_id,
            objective: project_step.objective,
            year: project_step.year,
            quarter: project_step.quarter,
            start_at: project_step.start_at,
            end_at: project_step.end_at
          };
        }

        this.setSelectedStep(this.selected);
      },
      getSelectedProjectStep() {
        const params = `project_step_id=${this.selectedStep.id}`;

        return api.get(`project_steps/get_project_step?${params}`).then(response => {
          const data = response.data;
          this.prevProjectStepId = data.prev_project_step_id;
          this.nextProjectStepId = data.next_project_step_id;
          this.setSelectedProjectStep(data.project_step);
        });
      },
      getLastProjectStep() {
        return api.get("project_steps/get_last_project_step").then(response => {
          const data = response.data;
          this.nextProjectStepId = null;
          this.prevProjectStepId = data.prev_project_step_id;
          this.setSelectedProjectStep(data.project_step);
        });
      },
      getLastProjectStepByParams() {
        if (this.newProjectStep) {
          return;
        }

        this.projectStepChanged(false);

        const params = `project_id=${this.selected.project_id}&` +
                       `year=${this.selected.year}&` +
                       `quarter=${this.selected.quarter}`;

        return api.get(`project_steps/get_last_project_step_by_params?${params}`).then(response => {
          const data = response.data;
          this.nextProjectStepId = null;
          this.prevProjectStepId = data.prev_project_step_id;
          this.setSelectedProjectStep(data.project_step);
        });
      },
      prevPrejectStep() {
        if (this.prevBtnDisabled) {
          return;
        }

        const params = `prev_project_step_id=${this.prevProjectStepId}`;

        return api.get(`project_steps/get_prev_project_step?${params}`).then(response => {
          const data = response.data;
          this.nextProjectStepId = this.selected.id;
          this.prevProjectStepId = data.prev_project_step_id;
          this.setSelectedProjectStep(data.project_step);
        });
      },
      nextPrejectStep() {
        if (this.nextBtnDisabled) {
          return;
        }

        const params = `next_project_step_id=${this.nextProjectStepId}`;

        return api.get(`project_steps/get_next_project_step?${params}`).then(response => {
          const data = response.data;
          this.nextProjectStepId = data.next_project_step_id;
          this.prevProjectStepId = this.selected.id;
          this.setSelectedProjectStep(data.project_step);
        });
      },
      changeStartAt(calendar) {
        this.selected.start_at = moment(calendar.date, 'D/M/YYYY').format('YYYY-MM-DD');
      },
      changeEndAt(calendar) {
        this.selected.end_at = moment(calendar.date, 'D/M/YYYY').format('YYYY-MM-DD');
      },
      async save() {
        const response = await this.saveProjectStep();

        if (response.data.status === "ok") {
          this.editDate = false;
          this.getSelectedProjectStep();
        }
      },
      newBoard() {
        const id = new Date().getTime();
        this.editDate = true;
        this.nextProjectStepId = null;
        this.prevProjectStepId = null;
        this.projectStepChanged(true);
        this.setNewProjectStep(true);
        const date = this.selected.end_at;
        this.selected.id = id;
        this.selected.start_at = moment(date, "YYYY-MM-DD").add(1, 'days');
        this.selected.end_at = moment(date, "YYYY-MM-DD").add(8, 'days');
        this.setSelectedStep(this.selected);

        const boards = ["priorities", "confidences", "next_projects", "health_metrics"]
        boards.forEach((board) => {
          this.refBoards[board].items.forEach((item, index) => {
            item.id = null;
            item.itemId = id + index;
          });
        });
      },
      updateCalendars() {
        const start_at = moment(this.selected.start_at, 'YYYY-MM-DD').format('D/M/YYYY');
        const end_at = moment(this.selected.end_at, 'YYYY-MM-DD').format('D/M/YYYY');

        if (this.$refs.start_at) {
          this.$refs.start_at.calendar.selectedDate = start_at;
          this.$refs.end_at.calendar.selectedDate = end_at;
        } else {
          this.$refs.start_at_disabled.value = start_at;
          this.$refs.end_at_disabled.value = end_at;
        }
      }
    },
    async created() {
      await this.getProjects();

      this.setNewProjectStep(false);
      this.projectStepChanged(false);

      if (this.selectedStep === null || this.selectedStep.id === null) {
        this.getLastProjectStep();
      } else {
        this.getSelectedProjectStep();
      }
    },
    updated() {
      this.updateCalendars();
    }
  }
</script>

<style scoped>
  .header {
    height: 10%;
    display: flex;
    flex-direction: row;
    align-items: center;
    background-color: rgba(0, 114, 255, 0.5);
    border-radius: 4px;
    padding: 15px;
  }

  label {
    margin-right: 5px;
  }

  .project {
    margin-right: 10px;
  }

  .year {
    width: 60px;
    margin-right: 10px;
  }

  .quarter {
    width: 60px;
    margin-right: 10px;
  }

  label[for=start_at] {
    width: 260px;
  }

  label[for=end_at] {
    width: 240px;
    margin-left: 10px;
  }

  .btn {
    width: 100px;
  }

  .btn-circle {
    width: 150px !important;
    height: 35px !important;
    padding: 0;
    padding-top: 7px;
    border-radius: 50%;
    margin-top: 5px;
    margin-left: 5px;
  }

  .disabled-date {
    width: 100px;
    text-align: center;
  }
</style>
