---
layout: default
title: Mon CV sportif
description: Benjamin, 30, Runner.
redirect_from:
  - /about
  - /about.html
permalink: /cv.html
cover: 2016/11/MR65-3.jpg
---

## CV Sportif

### Présentation

Benjamin Dos Santos, 30 ans, chausse du 42½, modeste routard reconverti à
l'ultra trail.

❤️ J'aime bien  : le Fartlek, les côtes, le zéro drop, les moutons Mérino, faire
du vélo, voyager, le saumon.

💔 J'aime pas trop : courir en ville, les descentes trop techniques, les filtres
snapchat, les foulées d'instagrameuses.

### Compétitions

{% assign year = 2013 %}
{% for post in site.categories["compétition"] %}
  {% capture thisyear %}
    {{ post.date | date: '%Y' }}
  {% endcapture %}
  {% if year != thisyear %}
  {% assign year=thisyear %}
<h4>{{ thisyear }}</h4>
  {% endif %}

  {{ post.country_emoji | append: ' ' }}[{{ post.title }}]({{ post.url }}) - <i>{{ post.distance }}, {{ post.elevation }}, {{ post.time }}</i>
{% endfor %}

#### 2009 à 2014

Principalement des courses sur route, dont entre autre les [10km Paris centre](http://www.10kmpariscentre.com/),
[10km de Reims](http://www.runinreims.com/fr), [10km l'Equipe](http://www.10km.lequipe.fr/),
[20km de Paris](http://www.20kmparis.com), [Paris-Versailles](http://www.parisversailles.com),
[Sedan-Charleville](#), [Semi-Marathon de Paris](http://www.semideparis.com) [...]

#### Map

<script src="https://embed.github.com/view/geojson/bdossantos/{{ site.name }}/master/_data/races.geojson?height=400&width=720"></script>

### Index de performance ITRA*

Trail category              | **Cotation ( / 1000)** |
:---------------------------|:-----------------------|
Trail Ultra XL ( >= 100 km)	|	N/A                    |
Trail Ultra L (70 to 99 km)	|	N/A                    |
Trail Ultra M (42 to 69 km)	| 531	                   |
Trail (<42km)	              | 585	                   |

_* [International Trail Running Association][ITRA]_

### Références chronométriques

**Distance**  | **Temps**   | **Course**                        | **Année**
:-------------|:------------|:----------------------------------|:--------------
10Km          | 38:32       | [10 Km de Clichy][10k]            | 2016
15Km          | 1:00:11     | [20 Km de Paris][15k]             | 2014
20Km          | 1:20:32     | [20 Km de Paris][20k]             | 2014
30Km          | 2:20:56     | [Ecotrail de Paris 30 Km][30k]    | 2016
Semi-Marathon | 1:32:00     | Sedan-Charleville (24,3Km)        | 2013
Marathon      | N/A         | N/A                               | N/A
50Km          | 6:29:44     | [Ecotrail Reykjavik 82 Km][50k]   | 2018
100Km         | 13:25:00    | [Ecotrail Reykjavik 82 Km][100k]  | 2018

### Formations

#### 2010 - 2012

Licencié à L'[ASPTT Athlétisme Charleville-Mézières][ASPTT], entrainé par
Pascal Billaudel. Merci à lui ainsi qu'à Christian Haquin de m'avoir appris à
courir.

### Me contacter

* [Site personnel][bds]
* [Twitter][twitter]
* [Google+][g+]
* [Strava][strava]

[10k]: https://www.strava.com/activities/515612740
[15k]: https://www.strava.com/activities/213348008
[20k]: https://www.strava.com/activities/213348008
[30k]: {{ site.baseurl }}{% post_url /2016/2016-03-19-ecotrail-de-paris-30Km %}
[50k]: {{ site.baseurl }}{% post_url /2018/2018-07-06-ecotrail-reykjavik-82km %}
[100k]: {{ site.baseurl }}{% post_url /2018/2018-07-06-ecotrail-reykjavik-82km %}
[ASPTT]: http://asptt08.athle.com/
[ITRA]: http://www.i-tra.org/community/benjamin.dos%20santos/557280/
[bds]: https://b-ds.fr
[twitter]: https://twitter.com/benjamin_ds
[g+]: https://plus.google.com/+BenjaminDosSantos
[strava]: https://www.strava.com/athletes/6925704

<!--
vim:spell spelllang=fr
-->
