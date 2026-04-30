class PokeScannerController < ApplicationController

  def create 
    unless params[:image].present?
      return render json: { error: "No image was recieved" }, status: :bad_request
    end

    user = User.first

    poke_scan = user.poke_scans.create!(
      cardName: "Scanning...",
      prediction: "Pending", 
      confidenceScore: 0.0
    )
    poke_scan.image.attach(params[:image])

    conn = Faraday.new(url:'http://127.0.0.1:8000') do |f|
      f.request :multipart
      f.request :url_encoded
      f.adapter Faraday.default_adapter
    end

    filePath = params[:image].tempfile.path
    mimeType = params[:image].content_type
    payload = {
      file: Faraday::Multipart::FilePart.new(filePath, mimeType)
    }

    begin
      response = conn.post('/pokeScan/', payload)
      aiData = JSON.parse(response.body)

      poke_scan.update(
        cardName: aiData['cardName'],
        prediction: aiData['prediction'],
        confidenceScore: aiData['confidenceScore'],
        reasoning: aiData['reasoning']
      )


      render json: {status: 'success', poke_scan:poke_scan}, status: :ok

    rescue => e

      puts "\n\n THERE WAS AND ERROR CONNECTING TO THE AI: #{e.message}\n\n"

      render json: {error: "There was an error with the Meowth Guard AI", real_error: e.message}, status: :service_unavailable

    end
  end
end
