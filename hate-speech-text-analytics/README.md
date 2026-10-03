# Hate Speech Detection on Social Media Using Text Analytics

**Goal:** Find out how hate speech differs from other social media posts in vocabulary, emotion, and topic, and whether those differences can be used to classify it.

**Data:** HateSpeechDataset (Kaggle). 440,000+ labeled social media posts, about 82% non-hate and 18% hate.

**Tools:** R (tidytext, topicmodels, tidyverse)

## Approach

1. **Sampling:** The full dataset exceeded R's 16 GB memory limit, so I drew a **stratified sample of 6,000 posts** (3,000 per class). This also fixed the class imbalance.
2. **Preprocessing:** tokenization, stop-word removal (including social media noise like "rt" and "http"), and numeric filtering
3. **Feature engineering:** character and word counts, exclamation marks, question marks, hashtags, mentions
4. **Analysis:**
   - TF-IDF to find the words most distinctive to each group
   - Sentiment and emotion analysis (Bing and NRC lexicons)
   - LDA topic modeling (k = 3 per group)
   - Bigram and trigram analysis
5. **Modeling:** Naive Bayes classifier

## Findings

- Hate speech uses a **narrower, more offensive vocabulary**.
- It is **much more negative**, with especially high anger and disgust on the NRC lexicon.
- Hate speech clusters around **three themes**: racial targeting, gender and sexual harassment, and political extremism. Non-hate posts cover a much wider range of topics.
- Hate speech also has distinctive multi-word phrases, not just offensive individual words.
- Switching from sparse per-post TF-IDF scores to **binary word-presence features** for the top 150 TF-IDF words, plus sentiment features, fixed a model that had been predicting a single class for every post.

## Limitations

A bag-of-words model can't detect sarcasm or coded language, and the analysis covers English posts only. Transformer models like BERT would be the next step.

## Files

- `Hate_Speech_Detection.R`: full analysis script
- `Hate_speech_Detection_report.pdf`: full report with figures
