// Configuration for a named entity recognization model based on:
//   Peters, Matthew E. et al. “Deep contextualized word representations.” NAACL-HLT (2018).
{
  "dataset_reader": {
    "type": "conll2003_sciie",
    "tag_label": "ner",
    "coding_scheme": "IOB1",
    "token_indexers": {
      "tokens": {
        "type": "single_id",
        "lowercase_tokens": true
      },
      "token_characters": {
        "type": "characters",
        "min_padding_length": 3
      }
    }
  },
  "train_data_path": std.extVar("NER_TRAIN_DATA_PATH"),
  "validation_data_path": std.extVar("NER_TEST_A_PATH"),
  "test_data_path": std.extVar("NER_TEST_B_PATH"),
  "evaluate_on_test": true,
  "model": {
    "type": "ner_tagger",
    "label_encoding": "IOB1",
    "constrain_crf_decoding": true,
    "calculate_span_f1": true,
    "dropout": 0.5,
    "include_start_end_transitions": false,
    "verbose_metrics": true,
    "text_field_embedder": {
      "token_embedders": {
        "tokens": {
            "type": "embedding",
            "embedding_dim": 100,
            "pretrained_file": "https://s3-us-west-2.amazonaws.com/allennlp/datasets/glove/glove.6B.100d.txt.gz",
            "trainable": true
        },
        "token_characters": {
            "type": "character_encoding",
            "embedding": {
                "embedding_dim": 16
            },
            "encoder": {
                "type": "cnn",
                "embedding_dim": 16,
                "num_filters": 128,
                "ngram_filter_sizes": [3],
                "conv_layer_activation": "relu"
            }
          }
       },
    },
    "encoder": {
        "type": "lstm",
        "input_size": 100 + 128,
        "hidden_size": 200,
        "num_layers": 2,
        "dropout": 0.4,
        "bidirectional": true
    },
  },
  "iterator": {
    "type": "basic",
    "batch_size": 128
  },
  "trainer": {
    "optimizer": {
        "type": "adam",
        "lr": 0.001
    },
    "validation_metric": "+f1-measure-overall",
    "num_serialized_models_to_keep": 3,
    "num_epochs":100,
    "grad_norm": 5.0,
    "patience": 25,
    "cuda_device": 0
  }
}
