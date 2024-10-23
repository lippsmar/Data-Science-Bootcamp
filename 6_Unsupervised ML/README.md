# 🎶 Moosic: Song Clustering with K-Means and PCA

## 📝 Overview
In this project, we aim to determine whether machine learning, specifically K-Means clustering, can automate the creation of cohesive song playlists, replacing manually curated lists. We will use **K-Means** for clustering and **PCA** for dimensionality reduction, analyzing a dataset of 5,000 songs.

## Table of Contents
- [📊 Data Preparation](#-data-preparation)
- [🏗 Feature Engineering](#-feature-engineering)
  - [Preprocessing the Audio Data](#preprocessing-the-audio-data)
  - [Scaling the Features](#scaling-the-features)
- [🏗 Analyzing Clusters](#-analyzing-clusters)
  - [Using Math to Determine the Number of Clusters](#using-math-to-determine-the-number-of-clusters)
  - [Using Business Sense to Determine the Number of Clusters](#using-business-sense-to-determine-the-number-of-clusters)
- [🏗 Principal Component Analysis (PCA)](#-principal-component-analysis-pca)
- [🏗 Presentation Preparation](#-presentation-preparation)
- [📊 Conclusion](#-conclusion)

---

## 📊 Data Preparation

### Step 1: Dataset Description
We are provided with a dataset containing 5,000 songs and several **audio features** for each song. These features include:
- **Acousticness**
- **Danceability**
- **Energy**
- **Instrumentalness**
- **Liveness**
- **Loudness**
- **Speechiness**
- **Tempo**

Our goal is to use this dataset to create cohesive song playlists, replacing the manual playlist creation process currently used by Moosic, a small startup.

### Step 2: Data Cleaning
Before using the dataset, we perform basic data cleaning:
- Handling missing values
- Dropping irrelevant columns (e.g., song titles)
- Converting the data types if necessary

---

## 🏗 Feature Engineering

### Preprocessing the Audio Data
The audio features provided are quite diverse, capturing different aspects of a song's characteristics. However, not all features are useful for clustering. Here’s how we process the data:
- **Categorical features**: If any exist, they are encoded.
- **Feature selection**: We drop features that are not relevant for clustering, keeping only continuous numerical features.
  
### Scaling the Features
Before applying clustering algorithms, it's crucial to **standardize** the dataset so that each feature contributes equally to the clustering process.

---

## 🏗 Analyzing Clusters

### K-Means Clustering
We start by applying K-Means clustering to the song dataset. K-Means is an iterative algorithm that groups similar data points into clusters.

### 📚 Using Math to Determine the Number of Clusters

1. **Inertia and the Elbow Method**
   - The inertia represents the sum of squared distances between each point and its closest centroid. Our goal is to minimize inertia, but increasing the number of clusters always reduces inertia. To find the optimal number of clusters, we use the Elbow Method, where we look for a point where the inertia drops sharply.

2. **Silhouette Coefficient**
   - The silhouette coefficient measures how similar each point is to its cluster compared to other clusters. It ranges from -1 (incorrect clustering) to +1 (perfect clustering). By plotting silhouette scores for various values of K, we can determine the optimal number of clusters.

### 📝 Using Business Sense to Determine the Number of Clusters
While mathematical methods help determine K, business needs also play a role. For Moosic, we aim for playlists with between 50 and 250 songs. Given the dataset of 5,000 songs, we explore a range of 20 to 100 clusters.

---

## 🏗 Principal Component Analysis (PCA)

### What is PCA?
PCA is used to reduce the dimensionality of the data while retaining as much variance as possible. This helps simplify the clustering process by focusing on the most important features.

### How PCA Works
PCA identifies the directions (principal components) that capture the most variance in the data. By projecting data onto these components, we reduce the number of features while maintaining critical information.

### Applying PCA with Scikit-Learn
To apply PCA in Scikit-Learn, you can specify either the number of components or the amount of variance to retain. Choose the method that best fits your needs, whether you know the number of components to keep or prefer to retain a certain percentage of variance.

---

## 🏗 Presentation Preparation

In our final presentation, we will demonstrate our prototype to Moosic’s startup team. The team is non-technical, so we’ll focus on the practical aspects of our solution. Our presentation will answer the following key questions:

- How did we create the prototype? (focus on the methodology, not the code)
- How many playlists (clusters) are there?
- What audio features were used, and why?
- Is the prototype effective at creating cohesive playlists?
- Does K-Means work well for creating playlists? (pros and cons)
- What are the next steps?

We will also showcase one or two playlists to demonstrate how well the clustering worked. The Q&A session will allow us to elaborate on any of the technical aspects if needed.

---

## 📊 Conclusion

This project demonstrates the power of machine learning for automating playlist creation using K-Means clustering and PCA for dimensionality reduction. While technical methods help shape the model, business requirements remain key to delivering a solution that meets practical needs.
