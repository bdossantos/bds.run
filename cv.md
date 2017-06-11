---
layout: default
title: Mon CV sportif
---

## Compétitions

{% assign year = 2013 %}
{% for post in site.categories["compétition"] %}
  {% capture thisyear %}
    {{ post.date | date: '%Y' }}
  {% endcapture %}
  {% if year != thisyear %}
  {% assign year=thisyear %}
<h3>{{ thisyear }}</h3>
  {% endif %}
{% if post.country %}{{ post.country | append: ' ' }}{% endif %}[{{ post.title }}]({{ post.url }}){% if post.summary %}<i>{{ post.summary | prepend: ' - ' }}</i>{% endif %}
{% endfor %}

### 2009 à 2014

Principalement des courses sur route, dont :

* [10km Paris centre](http://www.10kmpariscentre.com/)
* [10km de Reims](http://www.runinreims.com/fr)
* [10km l'Equipe](http://www.10km.lequipe.fr/)
* [20km de Paris](http://www.20kmparis.com)
* [Paris-Versailles](http://www.parisversailles.com)
* [Sedan-Charleville](#)
* [Semi-Marathon de Paris](http://www.semideparis.com)

## ITRA cotation *

Trail category              | **Cotation ( / 1000)** | **Cotation ( / 1000) Men's best cotation**
:---------------------------|:-----------------------|:------------------------------------------
Trail Ultra XL ( >= 100 km)	|	N/A                    | 919
Trail Ultra L (70 to 99 km)	|	N/A                    | 916
Trail Ultra M (42 to 69 km)	| 531	                   | 914
Trail (<42km)	              | 585	                   | 925

_* [International Trail Running Association][ITRA]_

## Références chronométriques

**Distance**  | **Temps**   | **Course**                    | **Année**
:-------------|:------------|:------------------------------|:--------------
10Km          | 38:32       | [10Km de Clichy][10k]         | 2016
15Km          | 1:00:11     | [20Km de Paris][15k]          | 2014
20Km          | 1:20:32     | [20Km de Paris][20k]          | 2014
30Km          | 2:20:56     | [Ecotrail de Paris 30Km][30k] | 2016
Semi-Marathon | 1:32:00     | Sedan-Charleville (24,3Km)    | 2013
Marathon      | N/A         | N/A                           | N/A

## Formation

### 2010 - 2012

Licencié à L'[ASPTT Athlétisme Charleville-Mézières][ASPTT], entrainé par
Pascal Billaudel. Merci à lui de m'avoir littéralement appris à courir.
Merci également à Christian Haquin, un sacré coureur qui m'a beaucoup inspiré et
appris.

[10k]: https://www.strava.com/activities/515612740
[15k]: https://www.strava.com/activities/213348008
[20k]: https://www.strava.com/activities/213348008
[30k]: https://www.strava.com/activities/520826081
[ASPTT]: http://asptt08.athle.com/
[ITRA]: http://www.i-tra.org/community/benjamin.dos%20santos/557280/
