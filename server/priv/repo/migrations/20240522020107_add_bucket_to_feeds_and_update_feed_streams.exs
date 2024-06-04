defmodule Orcasite.Repo.Migrations.AddBucketToFeedsAndUpdateFeedStreams do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:feeds) do
      add :bucket, :text
      add :bucket_region, :text
      add :cloudfront_url, :text
    end

    create index(:feeds, [:slug])

    create index(:feeds, [:visible])

    rename table(:feed_streams), :bucket_url, to: :bucket

    alter table(:feed_streams) do
      modify :bucket, :text
      add :bucket_region, :text
      add :cloudfront_url, :text
    end

    create index(:feed_streams, [:bucket])

    create unique_index(:feed_streams, [:feed_id, :start_time],
             name: "feed_streams_feed_stream_timestamp_index"
           )
  end

  def down do
    drop_if_exists unique_index(:feed_streams, [:feed_id, :start_time],
                     name: "feed_streams_feed_stream_timestamp_index"
                   )

    drop_if_exists index(:feed_streams, [:bucket])

    alter table(:feed_streams) do
      remove :cloudfront_url
      remove :bucket_region
      modify :bucket_url, :text
    end

    rename table(:feed_streams), :bucket, to: :bucket_url

    drop_if_exists index(:feeds, [:visible])

    drop_if_exists index(:feeds, [:slug])

    alter table(:feeds) do
      remove :cloudfront_url
      remove :bucket_region
      remove :bucket
    end
  end
end