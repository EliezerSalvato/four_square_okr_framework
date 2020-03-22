class Api::V1::ProjectsController < ApplicationController
  def index
    render json: Project.all.to_json
  end

  def create_or_update
    project = Project.find_by(id: params[:id])
    project ||= Project.new
    project.assign_attributes(project_params)

    if project.save
      render json: { id: project.id, status: :ok }
    else
      render json: { error: error_message(project), status: :error }
    end
  end

  def destroy
    Project.find(params[:id]).destroy
  end

  private

  def project_params
    params.require(:project).permit(
      :name
    )
  end

  def error_message(project)
    "#{project.errors.full_messages.first.humanize}."
  end
end
