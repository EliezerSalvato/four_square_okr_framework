<template>
  <div class="project-steps-board">
    <message-error />
    <message-success />
    <div class="project-steps-header">
      Project Steps
    </div>
    <div class="project-steps-data">
      <table>
        <thead>
          <tr>
            <th class="project-th">Project</th>
            <th class="objective-th">Objective</th>
            <th class="year-th">Year</th>
            <th class="quarter-th">Quarter</th>
            <th class="start-at-th">Start at</th>
            <th class="end-at-th">End at</th>
            <th class="save-th"></th>
            <th class="add-th">
              <input type="button" class="add" @click.prevent="addProjectStep" />
            </th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="project_step in project_steps" :key="project_step.id">
            <td>
              <select v-model="project_step.project_id"  :ref="project_step.id">
                <option
                  v-for="project in projects"
                  :key="project.id"
                  :value="project.id"
                  :selected="project.id == project_step.project_id ? 'selected' : ''"
                >
                  {{project.name}}
                </option>
              </select>
            </td>
            <td>
              <input type="text" class="objective" v-model="project_step.objective">
            </td>
            <td>
              <input type="number" class="year" v-model="project_step.year"
                onKeyDown="if (!isNaN(Number(event.key)) && this.value.length === 4) return false;"
              >
            </td>
            <td>
              <select v-model="project_step.quarter">
                <option
                  v-for="quarter in quarters"
                  :key="quarter"
                  :value="quarter"
                  :selected="quarter == project_step.quarter ? 'selected' : ''"
                >
                  {{quarter}}
                </option>
              </select>
            </td>
            <td>
              <FunctionalCalendar
                :is-date-picker="true"
                :sundayStart="true"
                :isModal="true"
                :ref="`start_at_${project_step.id}`"
                @choseDay="changeStartAt($event, project_step)"
              ></FunctionalCalendar>
            </td>
            <td>
              <FunctionalCalendar
                :is-date-picker="true"
                :sundayStart="true"
                :isModal="true"
                :ref="`end_at_${project_step.id}`"
                @choseDay="changeEndAt($event, project_step)"
              ></FunctionalCalendar>
            </td>
            <td>
              <input v-if="project_step.saved" type="button" class="btn" @click="open(project_step)" value="Open" />
              <input v-else type="button" class="btn" @click="save(project_step.id)" value="Save" />
            </td>
            <td class="remove-column">
              <input
                type="button"
                class="btn-remove"
                :class="{ 'btn-remove-disabled': !project_step.saved }"
                @click.prevent="remove(project_step.id)"
                value="x"
              />
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
  import moment from "moment";
  import { api } from "../services.js";
  import { mapState, mapActions } from "vuex";
  import MessageError from "../components/MessageError.vue";
  import MessageSuccess from "../components/MessageSuccess.vue";

  export default {
    name: "ProjectSteps",
    components: {
      MessageError,
      MessageSuccess
    },
    data() {
      return {
        projects: null,
        project_steps: null,
        watchers: [],
        quarters: ["Q1", "Q2", "Q3", "Q4"]
      }
    },
    computed: mapState(["selectedStep"]),
    methods: {
      ...mapActions(["setShowMessageSuccess", "setShowMessageError", "setSelectedStep"]),
      getProjects() {
        api.get("projects").then(response => {
          this.projects = response.data;
        });
      },
      getProjectSteps() {
        api.get("project_steps").then(response => {
          const items = response.data.map(item => ({ ...item, saved: true }));
          this.project_steps = items;
          this.setProjectStepWatchers();
        });
      },
      addProjectStep() {
        this.removeProjectStepWatchers();
        const date = new Date();
        const id = date.getTime();
        const start_at = moment(date, "YYYY-MM-DD");
        const end_at = moment(date, "YYYY-MM-DD").add(7, 'days');

        this.project_steps.push(
          {
            id: id,
            project_id: this.projects[0].id,
            year: date.getFullYear(),
            quarter: 'Q1',
            start_at: start_at,
            end_at: end_at,
            saved: false
          }
        );

        this.$setFocusByRefId(this.$refs, id);
        this.setProjectStepWatchers();
      },
      getProjectStep(id) {
        return this.project_steps.find(project_step => project_step.id === id);
      },
      getProjectStepIndex(project) {
        return this.project_steps.indexOf(project);
      },
      removeProjectStep(index) {
        this.removeProjectStepWatchers();
        this.project_steps.splice(index, 1);
        this.setProjectStepWatchers();
      },
      open(project_step) {
        this.setSelectedStep(project_step);
        this.$router.push({ path: '/' });
      },
      save(id) {
        const project_step = this.getProjectStep(id);

        return api.post("project_steps/create_or_update", project_step).then((response) => {
          if (response.data.status === "ok") {
            this.setShowMessageSuccess(true);
            project_step.id = response.data.id;
            project_step.saved = true;
          } else {
            this.setShowMessageError({ show: true, text: response.data.error });
          }
        });
      },
      changeStartAt(calendar, project_step) {
        project_step.start_at = moment(calendar.date, 'D/M/YYYY').format('YYYY-MM-DD');

      },
      remove(id) {
        const project_step = this.getProjectStep(id);

        if (!project_step.saved) {
          return;
        }

        var result = confirm("Are you sure you want to remove?");

        if (result === true) {
          if (this.selectedStep != null && this.selectedStep.id == id) {
            this.setSelectedStep(null);
          }

          api.delete(`/project_steps/${id}`).then(() => {
            this.setShowMessageSuccess({ show: true, text: "Successfully removed." });
            this.removeProjectStep(this.getProjectStepIndex(project_step));
          });
        }
      },
      setProjectStepWatchers() {
        this.project_steps.forEach((project_step, index) => {
          const keys = Object.keys(project_step).filter((key) => !['id', 'saved'].includes(key));

          keys.forEach((key) => {
            this.watchers.push(this.$watch(['project_steps', index, key].join('.'), () => {
              project_step.saved = false;
            }));
          });
        });
      },
      removeProjectStepWatchers() {
        this.watchers.forEach((unwatch) => {
          unwatch();
        });

        this.watchers = [];
      },
      changeEndAt(calendar, project_step) {
        project_step.end_at = moment(calendar.date, 'D/M/YYYY').format('YYYY-MM-DD');
      }
    },
    created() {
      this.getProjects();
      this.getProjectSteps();
    },
    updated() {
      for (let i = 0; i < this.project_steps.length; i++) {
        const project_step = this.project_steps[i];
        const start_at_calendar = this.$refs[`start_at_${project_step.id}`][0].calendar;
        const start_at = moment(project_step.start_at, 'YYYY-MM-DD').format('D/M/YYYY');
        start_at_calendar.selectedDate = start_at;
        const end_at_calendar = this.$refs[`end_at_${project_step.id}`][0].calendar;
        const end_at = moment(project_step.end_at, 'YYYY-MM-DD').format('D/M/YYYY');
        end_at_calendar.selectedDate = end_at;
      }
    }
  }
</script>

<style scoped>
  .project-steps-board {
    display: flex;
    flex-direction: column;
    width: 1200px;
    min-height: 750px;
    padding: 15px 40px;
    margin: 20px auto;
    border: 1px solid rgba(0, 114, 255, 0.6);
    box-shadow: 4px 4px 6px rgba(30, 60, 90, 0.1);
    background-color: rgba(0, 114, 255, 0.1);
  }

  .project-steps-header {
    display: flex;
    flex-direction: row;
    justify-content: center;
    padding: 20px;
    background-color: rgba(0, 114, 255, 0.8);
    color: white;
    border-radius: 4px;
    font-weight: bold;
  }

  .project-steps-data {
    margin-top: 15px;
    min-height: 640px;
    border: 1px solid rgba(0, 114, 255, 0.3);
  }

  table {
    padding: 5px;
    width: 100%;
    border-spacing: 0;
  }

  thead {
    height: 40px;
    background-color: rgba(0, 114, 255, 0.6);
    color: white;
    margin-left: 10px;
    width: 100%;
    text-align: left;
  }

  th {
    padding-left: 5px;
    padding-right: 5px;
  }

  .project-th {
    width: 40%;
  }

  .objective-th {
    width: 60%;
  }

  .year-th {
    min-width: 65px;
    text-align: center;
  }

  .quarter-th {
    width: 50px;
    text-align: center;
  }

  .start-at-th, .end-at-th {
    width: 100px;
    text-align: center;
  }

  .save-th {
    width: 100px;
  }

  .add-th {
    min-width: 45px;
    text-align: right;
  }

  .remove-column {
    text-align: right;
  }
</style>
