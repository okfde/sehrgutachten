## sehrgutachten

Gutachten des [Wissenschaftlichen Dienstes des Bundestags](http://bundestag.de/ausarbeitungen/), besser auflisten und durchsuchbar machen.


### Entwicklung

sehrgutachten ist eine Rails 5 (beta)-Anwendung. Du kannst dir eine Rails-Umgebung installieren, oder mittels [docker-compose](https://docs.docker.com/compose/) eine bereits fertig eingerichtete Umgebung benutzen.

#### Abhängigkeiten

* `poppler-utils` (für [docsplit](http://documentcloud.github.io/docsplit/))
* `elasticsearch` >= 2.0

### Jobs
Jobs laufen mittels ActiveJob.

Je nach Setup musst du bei den folgenden Kommandos `bundle exec` davorpacken, sodass die richtigen gems genutzt werden.

* Neue Papers importieren

  ```
  rake 'papers:import_new[wd1]'
  ```