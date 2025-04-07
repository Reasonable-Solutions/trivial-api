use axum::{routing::get, Router};
use tracing::{self, Level};

async fn say_hello() -> Result<String, (axum::http::StatusCode, String)> {
    Ok("hello".to_string())
}

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt().with_max_level(Level::INFO).init();
    tracing::info!("starting trivial-api");
    let app = Router::new().route("/trivial", get(say_hello));
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000")
        .await
        .expect("failed to bind port");
    axum::serve(listener, app).await.unwrap();
}
