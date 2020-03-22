class Api::V1::ProjectStepsController < ApplicationController
  def index
    render json: ProjectStep.order(start_at: :desc).to_json
  end

  def create_or_update
    project_step = ProjectStep.find_by(id: params[:id])
    project_step ||= ProjectStep.new
    project_step.assign_attributes(project_step_params)

    mark_for_destruction_not_existing_items(project_step, 'priorities')
    mark_for_destruction_not_existing_items(project_step, 'confidences')
    mark_for_destruction_not_existing_items(project_step, 'next_projects')
    mark_for_destruction_not_existing_items(project_step, 'health_metrics')

    if project_step.save
      render json: { id: project_step.id, status: :ok }
    else
      render json: { error: error_message(project_step), status: :error }
    end
  end

  def destroy
    ProjectStep.find(params[:id]).destroy
  end

  def get_project_step
    current_project_step = ProjectStep.find(params[:project_step_id])
    prev_project_step_id = prev_project_step_id(current_project_step)
    next_project_step_id = next_project_step_id(current_project_step)

    render json: {
      project_step: current_project_step,
      prev_project_step_id: prev_project_step_id,
      next_project_step_id: next_project_step_id
    }.to_json
  end

  def get_last_project_step
    current_project_step = ProjectStep.order(:start_at).last
    prev_project_step_id = prev_project_step_id(current_project_step)

    render json: {
      project_step: current_project_step,
      prev_project_step_id: prev_project_step_id
    }.to_json
  end

  def get_last_project_step_by_params
    current_project_step = ProjectStep.where(
      project_id: params[:project_id],
      year: params[:year],
      quarter: params[:quarter]
    ).order(:start_at).last
    prev_project_step_id = prev_project_step_id(current_project_step) if current_project_step.present?

    render json: {
      project_step: current_project_step,
      prev_project_step_id: prev_project_step_id
    }.to_json
  end

  def get_prev_project_step
    current_project_step = ProjectStep.find(params[:prev_project_step_id])
    prev_project_step_id = prev_project_step_id(current_project_step)

    render json: {
      project_step: current_project_step,
      prev_project_step_id: prev_project_step_id
    }.to_json
  end

  def get_next_project_step
    current_project_step = ProjectStep.find(params[:next_project_step_id])
    next_project_step_id = next_project_step_id(current_project_step)

    render json: {
      project_step: current_project_step,
      next_project_step_id: next_project_step_id
    }.to_json
  end

  def priorities
    project_step_priorities = ProjectStep.find(params[:id]).priorities.order(:priority, :content)

    render json: project_step_priorities.to_json
  end

  def confidences
    project_step_priorities = ProjectStep.find(params[:id]).confidences.order(:confidence, :content)

    render json: project_step_priorities.to_json
  end

  def next_projects
    project_step_priorities = ProjectStep.find(params[:id]).next_projects.order(:content)

    render json: project_step_priorities.to_json
  end

  def health_metrics
    project_step_priorities = ProjectStep.find(params[:id]).health_metrics.order(:content)

    render json: project_step_priorities.to_json
  end

  private

  def project_step_params
    params.require(:project_step).permit(
      :project_id,
      :year,
      :quarter,
      :start_at,
      :end_at,
      priorities_attributes: [
        :id, :project_step_id, :priority, :content, :annotations
      ],
      confidences_attributes: [
        :id, :project_step_id, :confidence, :content
      ],
      next_projects_attributes: [
        :id, :project_step_id, :content
      ],
      health_metrics_attributes: [
        :id, :project_step_id, :health, :content
      ]
    )
  end

  def project_step_query(current_project_step)
    ProjectStep.where(
      project_id: current_project_step.project_id,
      year: current_project_step.year,
      quarter: current_project_step.quarter
    ).where.not(
      id: current_project_step.id
    )
  end

  def prev_project_step_id(current_project_step)
    project_step_query(current_project_step).where(
      'start_at <= ?', current_project_step.start_at
    ).order(
      start_at: :desc
    ).limit(1).first.try(:id)
  end

  def next_project_step_id(current_project_step)
    project_step_query(current_project_step).where(
      'start_at >= ?', current_project_step.start_at
    ).order(
      :start_at
    ).limit(1).first.try(:id)
  end

  def mark_for_destruction_not_existing_items(project_step, item_type)
    attributes = project_step_params["#{item_type}_attributes"]

    return if attributes.blank?

    existing_item_ids = attributes.map { |item| item['id'] }

    project_step.send(item_type).each do |item|
      item.mark_for_destruction if existing_item_ids.exclude?(item.id)
    end
  end

  def error_message(project_step)
    project_step.errors.full_messages.first
  end
end
