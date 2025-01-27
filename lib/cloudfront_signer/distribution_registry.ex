defmodule CloudfrontSigner.DistributionRegistry do
  @moduledoc """
  Agent to store and fetch cloudfront distributions, to avoid expensive runtime pem decodes
  """
  use Agent

  alias CloudfrontSigner.Distribution

  require Logger

  def start_link(_opts) do
    Logger.info("Starting DistributionRegistry")
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get_distribution(scope, key) do
    Logger.info("Getting distribution for #{scope} #{key}")

    Agent.get_and_update(
      __MODULE__,
      &Map.get_and_update(&1, {scope, key}, fn
        nil ->
          dist = Distribution.from_config(scope, key)
          Logger.info("Distribution retrieved from config for #{scope} #{key}")
          {dist, dist}

        dist ->
          Logger.info("Distribution retrieved from cache for #{scope} #{key}")
          {dist, dist}
      end)
    )
  end
end
