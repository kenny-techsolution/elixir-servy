defmodule Servy.VideoCam do
  def getSnapshot(camera_name) do
    :timer.sleep(1000)
    "#{camera_name}-snapshot.jpg"
  end
end
