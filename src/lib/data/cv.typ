#import "@preview/clickworthy-resume:1.0.1": *

#let lang-input = sys.inputs.at("lang", default: "en")
#let profile-input = sys.inputs.at("profile", default: "dev")
#let tags-input = sys.inputs.at("tags", default: "")
#let summary-input = sys.inputs.at("summary", default: "")
#let exclude-tags-input = sys.inputs.at("exclude-tags", default: "")
#let exclude-ids-input = sys.inputs.at("exclude-ids", default: "")
#let only-ids-input = sys.inputs.at("only-ids", default: "")

#let parseList(input) = if input == "" { () } else { input.split(",").map(v => v.trim()) }

#let selectedTags = parseList(tags-input)
#let hasTagFilter = selectedTags.len() > 0
#let excludeTags = parseList(exclude-tags-input)
#let excludeIds = parseList(exclude-ids-input)
#let onlyIds = parseList(only-ids-input)
#let hasOnlyIds = onlyIds.len() > 0

#let matchesTags(item) = {
  if not hasTagFilter { true }
  else {
    item.at("tags", default: ()).any(tag => selectedTags.contains(tag))
  }
}

#let notExcluded(item) = {
  let itemTags = item.at("tags", default: ())
  let itemId = item.at("id", default: "")
  let hasExcludeTag = excludeTags.len() > 0 and itemTags.any(tag => excludeTags.contains(tag))
  let hasExcludeId = excludeIds.len() > 0 and excludeIds.contains(itemId)
  not hasExcludeTag and not hasExcludeId
}

#let shouldInclude(item) = {
  if hasOnlyIds {
    onlyIds.contains(item.at("id", default: ""))
  } else {
    matchesTags(item) and notExcluded(item)
  }
}

#let i18n = (
  en: (
    today: "Today",
    months: ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"),
    sections: (
      edu: "Education",
      ach: "Achievements",
      exp: "Experience",
      proj: "Projects",
      skills: "Skills",
    ),
    skills_label_tech: "Technical",
    skills_label_soft: "Foundational",
    soft_skills: (
      "Mathematics", "Physics", "Chemistry", "Statistics", "Pedagogy",
      "Problem Solving", "Logical Reasoning", "Discipline", "Communication",
      "Organization", "Teamwork",
    ),
  ),
  pt: (
    today: "Hoje",
    months: ("Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"),
    sections: (
      edu: "Educação",
      ach: "Conquistas",
      exp: "Experiência",
      proj: "Projetos",
      skills: "Habilidades",
    ),
    skills_label_tech: "Técnicas",
    skills_label_soft: "Fundamentais",
    soft_skills: (
      "Matemática", "Física", "Química", "Estatística", "Pedagogia",
      "Resolução de Problemas", "Raciocínio Lógico", "Disciplina", "Comunicação",
      "Organização", "Trabalho em Equipe",
    ),
  ),
).at(lang-input)

#let locale-dir = if lang-input == "pt" { "pt-br" } else { lang-input }
#let jsonPath(feature) = "./" + feature + "/" + locale-dir + ".json"

#let personalJson = json(jsonPath("personal"))
#let contactsJson = json(jsonPath("contacts"))
#let devJobsJson = json(jsonPath("experiences"))
#let tutorJobsJson = json(jsonPath("teaching"))
#let educationsJson = json(jsonPath("education"))
#let achievementsJson = json(jsonPath("achievements"))
#let projectsJson = json(jsonPath("projects"))

#let summary = if summary-input != "" {
  personalJson.at("summaries", default: (:)).at(summary-input, default: personalJson.summary)
} else {
  personalJson.summary
}

#let jobsJson = if hasTagFilter or hasOnlyIds {
  (devJobsJson + tutorJobsJson).filter(shouldInclude)
} else if profile-input == "tutor" {
  tutorJobsJson
} else if profile-input == "all" {
  devJobsJson + tutorJobsJson
} else {
  devJobsJson
}
#let includeProjects = hasTagFilter or hasOnlyIds or profile-input != "tutor"

#let sortKey(item) = item.at("start", default: item.at("date", default: ""))
#let mostRecentFirst(arr) = arr.sorted(key: sortKey).rev()

#let educationsJson = mostRecentFirst(educationsJson.filter(shouldInclude))
#let jobsJson = mostRecentFirst(jobsJson)
#let achievementsJson = mostRecentFirst(achievementsJson.filter(shouldInclude))
#let projectsJson = mostRecentFirst(projectsJson)
#let featuredProjectsJson = projectsJson.filter(p => p.at("featured", default: false))
#let shownProjectsJson = if hasTagFilter or hasOnlyIds { projectsJson.filter(shouldInclude) } else { featuredProjectsJson.filter(notExcluded) }

#let displayUrl(url) = url.replace(regex("^https?://"), "").trim("/")

// Keep each entry whole across a page break instead of splitting it mid-bullet.
#let noBreak(body) = block(breakable: false, body)

#let formatDate(exp) = {
  let formatPart(date) = {
    let arr = date.split("-")
    if arr.len() >= 2 {
      i18n.months.at(int(arr.at(1)) - 1) + " " + arr.at(0)
    } else {
      arr.at(0)
    }
  }

  let start = formatPart(exp.at("start"))
  let end = if exp.at("end", default: "") != "" {
    formatPart(exp.at("end"))
  } else {
    i18n.today
  }
  start + " - " + end
}

#show: resume.with(
  author: personalJson.name,
  contacts: contactsJson.map(c => [#link(c.url)[#c.display]]),
  summary: summary,
  theme-color: rgb("#8b1a1a"),
  font: "New Computer Modern",
  font-size: 11pt,
  lang: lang-input,
  margin: (top: 1cm, bottom: 0cm, left: 1cm, right: 1cm),
)

= #(i18n.sections.edu)
#for education in educationsJson [
  #noBreak(edu(
    institution: education.subtitle,
    date: formatDate(education),
    location: education.location,
    degrees: (),
    gpa: "",
    extra: education.title,
  ))
]

= #(i18n.sections.exp)
#for job in jobsJson [
  #noBreak(exp(
    title: job.title,
    organization: job.subtitle,
    date: formatDate(job),
    location: job.location,
    details: [
      #for detail in job.details [
        - #detail
      ]
    ],
  ))
]

= #(i18n.sections.ach)
#for achievement in achievementsJson [
  #noBreak(exp(
    title: achievement.title,
    organization: achievement.subtitle,
    date: achievement.at("date", default: ""),
    details: [
      #for detail in achievement.details [
        - #detail
      ]
      #if "link" in achievement and achievement.link != "" [
        - #link(achievement.link)[#displayUrl(achievement.link)]
      ]
    ],
  ))
]

#if includeProjects [
= #(i18n.sections.proj)
#for project in shownProjectsJson [
    #noBreak(exp(
      title: project.title,
      details: [
        #for detail in project.details [
          - #detail
        ]
        #if "link" in project and project.link != "" [
          - #link(project.link)[#displayUrl(project.link)]
        ]
      ],
    ))
  ]
]

= #(i18n.sections.skills)
#let allSkills = (
  jobsJson.map(j => j.skills).flatten()
    + achievementsJson.map(a => a.skills).flatten()
    + if includeProjects { shownProjectsJson.map(p => p.skills).flatten() } else { () }
)

#let uniqueSkills = allSkills.dedup()
#let isSoftSkill(s) = i18n.soft_skills.contains(s)
#let technicalSkills = uniqueSkills.filter(s => not isSoftSkill(s))
#let foundationalSkills = uniqueSkills.filter(isSoftSkill)

#skills((
  (i18n.skills_label_tech, technicalSkills.map(s => [#s])),
  (i18n.skills_label_soft, foundationalSkills.map(s => [#s])),
))
