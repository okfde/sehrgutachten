## sehrgutachten

Volltextsuche und Feeds für die Gutachten des [Wissenschaftlichen Dienstes des Bundestags](https://bundestag.de/ausarbeitungen/).


### Entwicklung

sehrgutachten ist eine Rails 5 (beta)-Anwendung. Du kannst dir eine Rails-Umgebung installieren, oder mittels [docker-compose](https://docs.docker.com/compose/) eine bereits fertig eingerichtete Umgebung benutzen.

#### Abhängigkeiten

* `poppler-utils` (für [docsplit](http://documentcloud.github.io/docsplit/))
* `elasticsearch` >= 2.0
*  apache tika server - z.B. [givemetext.okfnlabs.org](http://givemetext.okfnlabs.org/)
* `redis`

### Jobs
Jobs laufen mittels ActiveJob/Sidekiq.

Je nach Setup musst du bei den folgenden Kommandos `bundle exec` davorpacken, sodass die richtigen gems genutzt werden.

* Neue Papers importieren

  ```
  rake 'papers:import_all_new'
  ```

* Neue Papers herunterladen

  ```
  rake 'papers:download_new[wd1]'
  ```