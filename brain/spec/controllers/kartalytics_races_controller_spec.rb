require 'rails_helper'

describe KartalyticsRacesController, type: :controller do
  describe '#update' do
    let(:prev_course) { FactoryBot.create(:kartalytics_course, name: 'Waluigi Pinball') }
    let(:next_course) { FactoryBot.create(:kartalytics_course, name: 'Paris Promenade') }
    let(:match) { FactoryBot.create(:kartalytics_match) }
    let(:detected_image) { '1' }
    let(:race) do
      FactoryBot.create(
        :kartalytics_race,
        match: match,
        course: prev_course,
        detected_image: detected_image,
      )
    end

    before do
      allow(::Slack).to receive(:notify)
      post :update, params: { id: race.id, course: next_course.name }
    end

    it 'updates the course and audits the event' do
      expect(race.reload.course).to eq(next_course)
      expect(::Slack).to have_received(:notify).once.with(":alert: match##{match.id} race##{race.id} course manually reassigned from Waluigi Pinball to Paris Promenade")
    end

    context 'when detected_image is nil' do
      let(:detected_image) { nil }

      it 'does not update the course' do
        expect(race.reload.course).to eq(prev_course)
        expect(::Slack).not_to have_received(:notify)
        expect(flash[:alert]).to eq("Can't update course for race #{race.id} as start time is invalid")
      end
    end
  end
end
